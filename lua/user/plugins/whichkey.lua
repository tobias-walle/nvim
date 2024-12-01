---@type LazySpec
local plugin = {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function() require('which-key').setup({ delay = 300 }) end,
}

return plugin
