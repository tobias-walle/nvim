---@type LazySpec
local plugin = {
  -- Highlight trailing whitespace
  'echasnovski/mini.trailspace',
  lazy = false,
  config = function() require('mini.trailspace').setup() end,
}

return plugin
