local M = {}

local function write_cmd_stdout_to_buffer(cmd)
  local bufnr = vim.api.nvim_get_current_buf()
  -- Get the current cursor position
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  -- Normalize the row index for the buffer (1-indexed)
  row = row - 1
  -- Disable diagnostics to avoid interference
  vim.diagnostic.disable(bufnr)
  -- Set a placeholder for the output
  vim.api.nvim_buf_set_lines(bufnr, row, row, false, { 'Generating...' })
  -- Run the shell command and capture the output incrementally
  local output = ''
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        -- Make sure everything can be reverted in one action
        vim.cmd.undojoin()
        -- Set text in the buffer
        local lines_before = vim.split(output, '\n')
        output = output .. table.concat(data, '\n')
        local lines = vim.split(output, '\n')
        vim.api.nvim_buf_set_lines(
          bufnr,
          row,
          row + #lines_before,
          false,
          lines
        )
      end
    end,
    stdout_buffered = false,
    -- Cleanup
    on_exit = function(_, _)
      vim.keymap.del('n', '<Esc>')
      vim.diagnostic.enable(bufnr)
    end,
  })
  -- Cancel with esc
  vim.keymap.set('n', '<Esc>', function()
    print('Cancel...')
    vim.fn.jobstop(job_id)
  end, { noremap = true, silent = true })
end

function M.implement()
  local lang = vim.bo.filetype
  vim.ui.input({ prompt = 'Implement' }, function(prompt)
    if prompt then
      local escape = vim.fn.shellescape
      local cmd = string.format('implement %s %s', escape(lang), escape(prompt))
      write_cmd_stdout_to_buffer(cmd)
    end
  end)
end

return M
