---@type LazySpec
local plugin = {
  'petertriho/nvim-scrollbar',
  lazy = false,
  config = function() require('scrollbar').setup({}) end,
}

return plugin
