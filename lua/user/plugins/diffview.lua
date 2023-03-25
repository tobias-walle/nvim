---@type LazyPlugin
local plugin = {
  'sindrets/diffview.nvim',
  config = function()
    require('diffview').setup({})
  end,
}

return plugin
