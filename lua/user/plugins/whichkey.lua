---@type LazySpec
local plugin = {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({ preset = 'modern', delay = 300 })
  end,
}

return plugin
