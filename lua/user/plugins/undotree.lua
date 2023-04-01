---@type LazySpec
local plugin = {
  'mbbill/undotree',
  cmd = { 'UndotreeToggle' },
  config = function()
    vim.g.undotree_WindowLayout = 2
  end,
}

return plugin
