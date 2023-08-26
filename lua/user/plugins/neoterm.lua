---@type LazySpec
local plugin = {
  -- Autoclose brackets
  'kassio/neoterm',
  config = function() vim.g.neoterm_default_mod = 'belowright' end,
}

return plugin
