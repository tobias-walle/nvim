---@type LazyPlugin
local plugin = {
  -- Custom surround text objects for example to replace text in ``
  'echasnovski/mini.ai',
  config = function()
    require('mini.ai').setup()
  end,
}

return plugin
