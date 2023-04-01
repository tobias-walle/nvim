---@type LazySpec
local plugin = {
  'stevearc/dressing.nvim',
  lazy = false,
  config = function()
    require('dressing').setup({
      input = { insert_only = false },
    })
  end,
}

return plugin
