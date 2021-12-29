local M = {}

function M.reload()
  require'plenary.reload'.reload_module('user', true)
  require'plenary.reload'.reload_module('replace', true)
  local path = vim.env.MYVIMRC
  print('Reload ' .. path)
  vim.cmd('source ' .. path)
end

return M
