---@return LazyConfig
return {
  -- Autoclose brackets
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup({
      enable_moveright = true,
      fast_wrap = {},
    })
  end,
}
