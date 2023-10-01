-- Source: https://www.reddit.com/r/neovim/comments/12c4ad8/closing_unused_buffers/
local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup('close-unused-buffers', {
    clear = false,
  })

  local persistbuffer = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.fn.setbufvar(bufnr, 'bufpersist', 1)
  end

  vim.api.nvim_create_autocmd({ 'BufRead' }, {
    group = group,
    pattern = { '*' },
    callback = function()
      vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufModifiedSet' }, {
        buffer = 0,
        once = true,
        callback = persistbuffer,
      })
    end,
  })
end

M.close_unused_buffers = function()
  local curbufnr = vim.api.nvim_get_current_buf()
  local buflist = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buflist) do
    if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, 'bufpersist') ~= 1) then
      vim.cmd('bd ' .. tostring(bufnr))
    end
  end
end

M.close_unused_buffers_and_find_buffer = function()
  require('user.utils.autoclose-unused-buffers').close_unused_buffers()
  require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })
end

return M
