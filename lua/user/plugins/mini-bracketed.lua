---@type LazySpec
local plugin = {
  'echasnovski/mini.bracketed',
  lazy = false,
  config = function()
    require('mini.bracketed').setup({
      comment = { suffix = '' },
    })
  end,
}

return plugin
