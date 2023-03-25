---@type LazyPlugin
local plugin = {
  'folke/which-key.nvim',
  config = function()
    require('which-key').setup({})
  end,
}

return plugin
