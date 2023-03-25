---@type LazyPlugin
local plugin = {
  -- Highlight trailing whitespace
  'echasnovski/mini.trailspace',
  config = function()
    require('mini.trailspace').setup()
  end,
}

return plugin
