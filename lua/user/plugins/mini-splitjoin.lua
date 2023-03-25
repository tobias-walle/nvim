---@type LazyPlugin
local plugin = {
  -- Jump to last buffer if a buffer gets removed
  'echasnovski/mini.splitjoin',
  config = function()
    require('mini.splitjoin').setup({
      mappings = {
        toggle = 'gS',
      },
    })
  end,
}

return plugin
