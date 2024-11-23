local M = {}

function M.show_fidget_history_in_popup()
  -- Get history and create popup buffer
  local history = require('fidget').notification.get_history()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = vim.api.nvim_get_option('columns')
  local height = vim.api.nvim_get_option('lines')

  -- Calculate window size and position
  local win_height = math.ceil(height * 0.8)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  -- Create floating window
  local opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Write messages to buffer
  local messages = {}
  for _, msg in ipairs(history) do
    for i, line in ipairs(vim.split(msg.message, '\n')) do
      if i == 1 and msg.annote then
        line = string.format('[%s] %s', msg.annote, line)
      end
      table.insert(messages, line)
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, messages)

  -- Scroll to end of buffer
  vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'fidget-history')

  -- Close buffer with q
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    'q',
    ':close<CR>',
    { noremap = true, silent = true }
  )
end

return M
