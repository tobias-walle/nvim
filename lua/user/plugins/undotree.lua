---@type LazyPlugin
local plugin = {
  'mbbill/undotree',
  config = function()
    vim.g.undotree_WindowLayout = 2
  end,
}

return plugin
