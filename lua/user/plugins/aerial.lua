---@type LazyPlugin
local plugin = {
  -- Shows outline of source code
  'stevearc/aerial.nvim',
  config = function()
    require('aerial').setup()
  end,
}

return plugin
