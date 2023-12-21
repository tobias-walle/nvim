---@type LazySpec
local plugin = {
  'AckslD/nvim-neoclip.lua',
  lazy = false,
  config = function() require('neoclip').setup() end,
}

return plugin
