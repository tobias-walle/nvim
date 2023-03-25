---@type LazyPlugin
local plugin = {
  -- Nushell language support
  'LhKipp/nvim-nu',
  config = function()
    require('nu').setup({})
  end,
}

return plugin
