local M = {}

function M.copy_relative_path()
  local path = vim.fn.expand('%:~:.')
  if path:match('^oil:///') then
    local abs_path = path:gsub('^oil:///', '/')
    path = vim.fn.fnamemodify(abs_path, ':~:.')
  end
  if path == '' then
    path = './'
  end
  vim.fn.setreg('+', path)
  vim.fn.setreg('*', path)
  vim.notify('Copied ' .. path, vim.log.levels.INFO, { title = 'Path Copied' })
end

return M
