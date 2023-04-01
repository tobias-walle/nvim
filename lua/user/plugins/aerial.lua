---@type LazySpec
local plugin = {
  -- Shows outline of source code
  'stevearc/aerial.nvim',
  event = 'VeryLazy',
  config = function()
    require('aerial').setup()
  end,
}

return plugin
