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
  local parent_folder = vim.fn.fnamemodify(destination, ':h')
  vim.api.nvim_command('silent !mkdir -p ' .. M.quote(parent_folder))
  vim.api.nvim_command('silent !gmv -T ' .. M.quote(source) .. ' ' .. M.quote(destination))
  vim.api.nvim_command('silent !rm -d ' .. M.quote(source))
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
--- @param commands string[]
--- @param callback nil | fun (): nil
--- @return nil
function M.show_terminal_popup(title, commands, callback)
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

  local termclose_au = nil

  popup:on({event.BufLeave}, function()
    popup:unmount()
    if (termclose_au ~= nil) then vim.api.nvim_del_autocmd(termclose_au) end
    if (callback ~= nil) then callback() end
  end, {once = true})

  local function next_command(i)
    print(i)
    local command = commands[i]

    termclose_au = vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*',
      once = true,
      callback = function()
        vim.schedule(function()
          if (i == M.size(commands)) then
            popup:unmount()
            if (callback ~= nil) then callback() end
          else
            next_command(i + 1)
          end
        end)
      end
    })

    vim.api.nvim_command('terminal ' .. command)
    if (i == 1) then vim.api.nvim_input('a') end
  end

  next_command(1)
end

--- @param source string
--- @param destination string
--- @param callback nil | fun (): nil
local function refactor_file_usages_exact_filename_command(source, destination, callback)
  local source_file_name = vim.fn.fnamemodify(source, ':t')
  local destination_file_name = vim.fn.fnamemodify(destination, ':t')
  local regex = string.gsub(source_file_name, '%.', '\\.') .. '(["\\\'])'
  local replacement = destination_file_name .. '$1'
  return 'fastmod ' .. M.quote(regex) .. ' ' .. M.quote(replacement)
end

--- @param source string
--- @param destination string
--- @param callback nil | fun (): nil
local function refactor_file_usages_without_ending_command(source, destination, callback)
  local source_file_name = vim.fn.fnamemodify(source, ':t:r')
  local destination_file_name = vim.fn.fnamemodify(destination, ':t:r')
  if (source_file_name == destination_file_name) then return end

  local regex = '/' .. string.gsub(source_file_name, '%.', '\\.') .. '(["\\\'])'
  local replacement = '/' .. destination_file_name .. '$1'
  return 'fastmod ' .. M.quote(regex) .. ' ' .. M.quote(replacement)
end

--- @param source string
--- @param destination string
function M.refactor_file_usages(source, destination)
  M.show_terminal_popup('Rename', {
    refactor_file_usages_exact_filename_command(source, destination),
    refactor_file_usages_without_ending_command(source, destination)
  })
end

--- @param old_name string
--- @param new_name string
function M.rename_top_level_declarations(old_name, new_name) end

--- @param name string
--- @return { start_pos: [integer, integer], end_pos: [integer, integer] }[]
function M.find_top_level_declarations(name)
  local tokens = {
    'export_statement declaration: (_ name: (_) @name (#offset! @name))',
    'export_statement declaration: (_ (variable_declarator name: (_) @name (#offset! @name)))'
  }
  local predicate = '(#eq? @name "' .. name .. '")'

  local filetype = vim.bo.filetype
  local parser = vim.treesitter.get_parser(0, filetype)
  local test = parser:parse()
  local root = test[1]:root()
  local results = {}
  for _, token_query in ipairs(tokens) do
    local query_str = '(\n' .. token_query .. '\n' .. predicate .. '\n)'
    local query = vim.treesitter.parse_query(filetype, query_str)
    for _, match, metadata in query:iter_matches(root, 0) do
      local name = vim.treesitter.get_node_text(match[1], 0)
      local pos = metadata.content[1]
      local start_pos = {pos[1] + 1, pos[2] + 1}
      local end_pos = {pos[3] + 1, pos[4] + 1}
      table.insert(results, {name, start_pos = start_pos, end_pos = end_pos})
      break
    end
  end
  return results
end

--- @param new_name string
function M.lsp_rename_sync(new_name)
  local params = vim.lsp.util.make_position_params()
  params.newName = new_name
  local responses = vim.lsp.buf_request_sync(0, 'textDocument/rename', params)
  if (responses == nil) then
    print('Nothing to rename')
    return
  end
  for _, response in pairs(responses) do
    vim.lsp.util.apply_workspace_edit(response.result, 'utf-8')
  end
  vim.api.nvim_command('wa')
end

vim.api.nvim_set_keymap('n', '<leader>.', '', {
  noremap = true,
  callback = function() M.find_top_level_declarations('api') end
})

return M
