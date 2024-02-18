---@type LazySpec
local plugin = {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  config = function() require('copilot').setup({}) end,
}

return plugin
