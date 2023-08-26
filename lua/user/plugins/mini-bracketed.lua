---@type LazySpec
local plugin = {
  'echasnovski/mini.bracketed',
  lazy = false,
  config = function() require('mini.bracketed').setup({}) end,
}

return plugin
