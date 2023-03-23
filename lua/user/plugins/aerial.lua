---@return LazyConfig
return {
  -- Shows outline of source code
  'stevearc/aerial.nvim',
  config = function()
    require('aerial').setup()
  end,
}
