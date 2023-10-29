---@type LazySpec
local plugin = {
  'echasnovski/mini.jump',
  lazy = false,
  enabled = false, -- Disable for now to test if I really want it
  config = function()
    require('mini.jump').setup({
      mappings = {
        forward = 'f',
        backward = 'F',
        forward_till = 't',
        backward_till = 'T',
        repeat_jump = ';',
      },
      delay = {
        highlight = 10000000,
        idle_stop = 3000,
      },
    })
  end,
}

return plugin
