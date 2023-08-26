---@type LazySpec
local plugin = {
  'alvarosevilla95/luatab.nvim',
  lazy = false,
  config = function() require('luatab').setup({}) end,
}

return plugin
