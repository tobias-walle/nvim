---@type LazyPlugin
local plugin = {
  -- Jump to last buffer if a buffer gets removed
  'echasnovski/mini.bufremove',
  config = function()
    require('mini.bufremove').setup()
  end,
}

return plugin
