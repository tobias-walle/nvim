---@type LazySpec
local plugin = {
  -- Nushell language support
  'LhKipp/nvim-nu',
  event = 'VeryLazy',
  config = function()
    require('nu').setup({})
  end,
}

return plugin
