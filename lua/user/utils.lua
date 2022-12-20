local M = {}

local async = require('plenary.async')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

function dbg(arg)
  print(vim.inspect(arg))
  return arg
end

--- @param variable unknown
--- @param name string
--- @param expected_type string
function M.assert_type(variable, name, expected_type)
  local actual_type = type(variable)
  assert(
    actual_type == expected_type,
    'Expected type of "' .. name .. '" to be "' .. expected_type .. '", but it was actual "' .. actual_type .. '"'
  )
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

--- @generic T
--- @generic R
--- @param list T[]
--- @param check fun (item: T, index: integer): boolean
--- @return T | nil
function M.find(list, check)
  for i, v in ipairs(list) do
    if check(v, i) then
      return v
    end
  end

  return nil
end

--- @generic T
--- @param list T[]
--- @return integer
function M.len(list)
  local count = 0
  for _, _ in ipairs(list) do
    count = count + 1
  end
  return count
end

--- @generic T
--- @generic R
--- @param list T[]
--- @param check fun (item: T, index: integer): boolean
--- @return boolean
function M.some(list, check)
  return M.find(list, check) ~= nil
end

--- @param table table
--- @return integer
function M.size(table)
  local size = 0
  for _, _ in ipairs(table) do
    size = size + 1
  end
  return size
end

--- @param items string[]
--- @param seperator string
--- @return string
function M.join(items, seperator)
  local result = ''
  for i, v in ipairs(items) do
    if i > 1 then
      result = result .. seperator
    end
    result = result .. v
  end
  return result
end

--- @param ... string
--- @return string
function M.join_path(...)
  return M.join({ ... }, '/')
end

--- @param command string[]
--- @param callback fun (): nil
function M.run_cmd(command, callback)
  print('> ' .. M.join(command, ' '))
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(M.join(data, '\n'))
      end
    end,
    on_stderr = function(_, data)
      local message = M.join(data, '\n')
      if data ~= '' then
        vim.notify(message, vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_)
      if callback then
        callback()
      end
    end,
  })
end

--- @type fun (command: string[]): nil
M.run_cmd_async = async.wrap(M.run_cmd, 2)

--- @type fun (opts: table): string
M.input_async = async.wrap(function(opts, on_confirm)
  vim.ui.input(opts, on_confirm)
end, 2)

--- @param content string
--- @return string
function M.quote(content)
  return "'" .. content .. "'"
end

--- @param title string
--- @param content string[]
--- @param callback fun (edited_content: string[]): nil
--- @return nil
function M.show_edit_popup(title, content, callback)
  local popup = Popup({
    enter = true,
    relative = 'editor',
    border = { style = 'rounded', text = { top = ' ' .. title .. ' ' } },
    position = '50%',
    size = { width = '90%', height = '60%' },
    buf_options = { modifiable = true, readonly = false },
    win_options = { winhighlight = 'Normal:Normal,FloatBorder:SpecialChar' },
  })
  popup:mount()

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, content)

  popup:on({ event.BufLeave }, function()
    popup:unmount()
  end, { once = true })

  popup:map('n', '<CR>', function()
    local edited_content = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, false)
    popup:unmount()
    callback(edited_content)
  end)
end

--- @type fun (title: string, content: string[]): string[]
M.show_edit_popup_async = async.wrap(M.show_edit_popup, 3)

--- @param title string
--- @param commands string[]
--- @param callback nil | fun (): nil
--- @return nil
function M.show_terminal_popup(title, commands, callback)
  local popup = Popup({
    enter = true,
    relative = 'editor',
    border = { style = 'rounded', text = { top = ' ' .. title .. ' ' } },
    position = '50%',
    size = { width = '90%', height = '90%' },
    buf_options = { modifiable = true, readonly = false },
    win_options = { winhighlight = 'Normal:Normal,FloatBorder:SpecialChar' },
  })
  popup:mount()

  local termclose_au = nil

  popup:on({ event.BufLeave }, function()
    popup:unmount()
    if termclose_au ~= nil then
      vim.api.nvim_del_autocmd(termclose_au)
    end
    if callback ~= nil then
      callback()
    end
  end, { once = true })

  local function next_command(i)
    print(i)
    local command = commands[i]

    termclose_au = vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*',
      once = true,
      callback = function()
        vim.schedule(function()
          if i == M.size(commands) then
            popup:unmount()
            if callback ~= nil then
              callback()
            end
          else
            next_command(i + 1)
          end
        end)
      end,
    })

    vim.api.nvim_command('terminal ' .. command)
    if i == 1 then
      vim.api.nvim_input('a')
    end
  end

  next_command(1)
end

--- @type fun (title: string, commands: string[]): nil
M.show_terminal_popup_async = async.wrap(M.show_terminal_popup, 3)

--- @param s string
--- @param prefix string
function M.starts_with(s, prefix)
  return string.sub(s, 1, string.len(prefix)) == prefix
end

return M
