---@type LazySpec
local plugin = {
  -- Jump to last buffer if a buffer gets removed
  'echasnovski/mini.bufremove',
  lazy = false,
  config = function()
    require('mini.bufremove').setup()
  end,
}

return plugin
