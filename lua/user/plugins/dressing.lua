---@type LazySpec
local plugin = {
  'stevearc/dressing.nvim',
  lazy = false,
  config = function()
    require('dressing').setup({
      input = { insert_only = false },
      select = {
        enabled = true,
        telescope = require('telescope.themes').get_ivy({}),
      },
    })
  end,
}

return plugin
