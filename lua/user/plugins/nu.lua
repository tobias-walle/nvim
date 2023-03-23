---@return LazyConfig
return {
  -- Nushell language support
  'LhKipp/nvim-nu',
  config = function()
    require('nu').setup({})
  end,
}
