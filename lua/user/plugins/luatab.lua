---@type LazyPlugin
local plugin = {
  'alvarosevilla95/luatab.nvim',
  config = function()
    require('luatab').setup({})
  end,
}

return plugin
