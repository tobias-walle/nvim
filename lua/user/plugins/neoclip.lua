---@type LazyPlugin
local plugin = {
  'AckslD/nvim-neoclip.lua',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  event = 'VeryLazy',
  config = function() require('neoclip').setup({}) end,
}

return plugin
