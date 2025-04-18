---@type LazySpec
local plugin = {
  'gbprod/yanky.nvim',
  lazy = false,
  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 100,
    },
  },
  dependencies = { 'folke/snacks.nvim' },
}

return plugin
