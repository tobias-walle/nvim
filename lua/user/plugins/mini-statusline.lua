---@type LazySpec
local plugin = {
  'echasnovski/mini.statusline',
  lazy = false,
  config = function()
    require('mini.statusline').setup()
  end,
}

return plugin
