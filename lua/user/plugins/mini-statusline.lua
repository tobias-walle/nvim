---@type LazyPlugin
local plugin = {
  'echasnovski/mini.statusline',
  config = function()
    require('mini.statusline').setup()
  end,
}

return plugin
