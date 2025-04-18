---@type LazySpec
local plugin = {
  'gbprod/yanky.nvim',
  lazy = false,
  opts = {
    highlight = {
      on_put = false,
      on_yank = true,
      timer = 300,
    },
  },
  dependencies = { 'folke/snacks.nvim' },
}

return plugin
