---@type LazySpec
local plugin = {
  {
    'robitx/gp.nvim',
    event = 'VeryLazy',
    config = function() require('gp').setup() end,
  },
}

return plugin
