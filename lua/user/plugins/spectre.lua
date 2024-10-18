---@type LazySpec
local plugin = {
  'nvim-pack/nvim-spectre',
  enabled = true,
  event = 'BufEnter',
  config = function() require('spectre').setup() end,
}

return plugin
