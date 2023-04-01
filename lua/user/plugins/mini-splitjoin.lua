---@type LazySpec
local plugin = {
  'echasnovski/mini.splitjoin',
  lazy = false,
  config = function()
    require('mini.splitjoin').setup({
      mappings = {
        toggle = 'gj',
      },
    })
  end,
}

return plugin
