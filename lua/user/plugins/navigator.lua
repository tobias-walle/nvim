---@type LazySpec
local plugin = {
  'numToStr/Navigator.nvim',
  lazy = false,
  config = function() require('Navigator').setup() end,
}

return plugin
