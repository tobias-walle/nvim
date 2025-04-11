---@type LazySpec
local plugin = {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  config = function() require('gitsigns').setup() end,
}

return plugin
