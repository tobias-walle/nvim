---@type LazySpec
local plugin = {
  {
    'zbirenbaum/copilot.lua',
    cmd = { 'Copilot' },
    config = function() require('copilot').setup({}) end,
  },
}

return plugin
