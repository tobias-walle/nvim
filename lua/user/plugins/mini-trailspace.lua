---@type LazySpec
local plugin = {
  -- Highlight trailing whitespace
  'echasnovski/mini.trailspace',
  event = 'VeryLazy',
  config = function()
    require('mini.trailspace').setup()
  end,
}

return plugin
