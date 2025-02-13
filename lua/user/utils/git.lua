local M = {}

function M.insert_git_log_message()
  -- Get git log messages with hash and subject
  local handle = io.popen('git log --format="%h %s" -n 10')
  if not handle then
    vim.notify('Failed to execute git log command', vim.log.levels.ERROR)
    return
  end

  -- Read and parse the git log output
  local logs = {}
  local log_messages = {}
  for line in handle:lines() do
    table.insert(logs, line)
    -- Store just the commit message without hash for display
    table.insert(log_messages, vim.trim(line:sub(8)))
  end
  handle:close()

  if #logs == 0 then
    vim.notify('No git logs found', vim.log.levels.WARN)
    return
  end

  -- Use vim.ui.select to choose a message
  vim.ui.select(log_messages, {
    prompt = 'Select git commit message:',
    format_item = function(item) return item end,
  }, function(choice, idx)
    if choice then
      -- Get the current buffer and cursor position
      local bufnr = vim.api.nvim_get_current_buf()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      -- Insert the selected message at cursor position
      vim.api.nvim_buf_set_text(
        bufnr,
        row - 1, -- Convert to 0-based index
        col,
        row - 1,
        col,
        { choice }
      )
    end
  end)
end

return M
