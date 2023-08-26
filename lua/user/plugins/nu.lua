---@type LazySpec
local plugin = {
  -- Nushell language support
  'LhKipp/nvim-nu',
  enabled = false,
  config = function() require('nu').setup({}) end,
}

return plugin
