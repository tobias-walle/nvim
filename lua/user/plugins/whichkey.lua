---@type LazySpec
local plugin = {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({})
  end,
}

return plugin
