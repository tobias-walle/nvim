local M = {}

local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

--- @param variable unknown
--- @param name string
--- @param expected_type string
function M.assert_type(variable, name, expected_type)
  local actual_type = type(variable)
  assert(actual_type == expected_type,
         'Expected type of "' .. name .. '" to be "' .. expected_type .. '", but it was actual "' ..
           actual_type .. '"')
end

--- @generic T
--- @generic R
--- @param list T[]
--- @param mapper fun (item: T, index: integer): R
--- @return R[]
function M.map(list, mapper)
  local new_table = {}
  for i, v in ipairs(list) do
    local new_v = mapper(v, i)
    new_table[i] = new_v
  end

  return new_table
end

--- @param table table
--- @return integer
function M.size(table)
  local size = 0
  for _, _ in ipairs(table) do size = size + 1 end
  return size
end

--- @param items string[]
--- @param seperator string
--- @return string
function M.join(items, seperator)
  local result = ''
  for i, v in ipairs(items) do
    if i > 1 then result = result .. seperator end
    result = result .. v
  end
  return result
end

--- @param ... string
--- @return string
function M.join_path(...) return M.join({...}, '/') end

--- @param source string
--- @param destination string
--- @return nil
function M.file_move(source, destination)
  vim.api.nvim_command('silent !mv "' .. source .. '" "' .. destination .. '"')
end

--- @param content string
--- @return string
function M.quote(content) return '\'' .. content .. '\'' end

--- @param title string
--- @param content string[]
--- @param callback fun (edited_content: string[]): nil
--- @return nil
function M.show_edit_popup(title, content, callback)
  local popup = Popup({
    enter = true,
    relative = 'editor',
    border = {style = 'rounded', text = {top = ' ' .. title .. ' '}},
    position = '50%',
    size = {width = '90%', height = '60%'},
    buf_options = {modifiable = true, readonly = false},
    win_options = {winhighlight = 'Normal:Normal,FloatBorder:SpecialChar'}
  })
  popup:mount()

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, content)

  popup:on({event.BufLeave}, function() popup:unmount() end, {once = true})

  popup:map('n', '<CR>', function()
    local edited_content = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, false)
    popup:unmount()
    callback(edited_content)
  end)
end

--- @param title string
--- @param command string
--- @param callback nil | fun (): nil
--- @return nil
function M.show_terminal_popup(title, command, callback)
  local popup = Popup({
    enter = true,
    relative = 'editor',
    border = {style = 'rounded', text = {top = ' ' .. title .. ' '}},
    position = '50%',
    size = {width = '90%', height = '90%'},
    buf_options = {modifiable = true, readonly = false},
    win_options = {winhighlight = 'Normal:Normal,FloatBorder:SpecialChar'}
  })
  popup:mount()

  local termclose_au = vim.api.nvim_create_autocmd('TermClose', {
    pattern = '*',
    once = true,
    callback = function()
      vim.schedule(function()
        popup:unmount()
        if (callback ~= nil) then callback() end
      end)
    end
  })

  popup:on({event.BufLeave}, function()
    popup:unmount()
    vim.api.nvim_del_autocmd(termclose_au)
    if (callback ~= nil) then callback() end
  end, {once = true})

  vim.api.nvim_command('terminal ' .. command)
  vim.api.nvim_input('a')
end

--- @param source string
--- @param destination string
--- @param callback nil | fun (): nil
function M.refactor_file_usages_exact_filename(source, destination, callback)
  local source_file_name = vim.fn.fnamemodify(source, ':t')
  local destination_file_name = vim.fn.fnamemodify(destination, ':t')
  local regex = string.gsub(source_file_name, '%.', '\\.') .. '(["\\\'])'
  local replacement = destination_file_name .. '$1'
  local command = 'fastmod ' .. M.quote(regex) .. ' ' .. M.quote(replacement)
  print(command)
  M.show_terminal_popup('Rename ' .. source_file_name .. ' (1)', command, callback)
end

--- @param source string
--- @param destination string
--- @param callback nil | fun (): nil
function M.refactor_file_usages_without_ending(source, destination, callback)
  local source_file_name = vim.fn.fnamemodify(source, ':t:r')
  local destination_file_name = vim.fn.fnamemodify(destination, ':t:r')
  if (source_file_name == destination_file_name) then return end

  local regex = '/' .. string.gsub(source_file_name, '%.', '\\.') .. '(["\\\'])'
  local replacement = '/' .. destination_file_name .. '$1'
  local command = 'fastmod ' .. M.quote(regex) .. ' ' .. M.quote(replacement)
  print(command)
  M.show_terminal_popup('Rename ' .. source_file_name .. ' (2)', command, callback)
end

--- @param source string
--- @param destination string
function M.refactor_file_usages(source, destination)
  M.refactor_file_usages_exact_filename(source, destination, function()
    M.refactor_file_usages_without_ending(source, destination)
  end)
end

return M
