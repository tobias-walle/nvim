---@type LazyPlugin
local plugin = {
  'petertriho/nvim-scrollbar',
  config = function()
    require('scrollbar').setup({})
  end,
}

return plugin
