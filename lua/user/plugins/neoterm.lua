---@type LazyPlugin
local plugin = {
  -- Autoclose brackets
  'kassio/neoterm',
  lazy = true,
  config = function()
    vim.g.neoterm_default_mod = 'belowright'
  end,
}

return plugin
