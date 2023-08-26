local M = {}

vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

function M.prefer_local()
  vim.cmd.MergetoolPreferLocal()
  vim.g.mergetool_layout = 'mr'
  vim.cmd.MergetoolToggleLayout('mr')
end

function M.prefer_remote()
  vim.cmd.MergetoolPreferRemote()
  vim.g.mergetool_layout = 'ml'
  vim.cmd.MergetoolToggleLayout('ml')
end

return M
