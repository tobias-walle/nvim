---@type LazyPlugin
local plugin = {
  'stevearc/dressing.nvim',
  config = function()
    require('dressing').setup({
      input = { insert_only = false },
    })
  end,
}

return plugin
