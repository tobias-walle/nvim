---@type LazySpec
local plugin = {
  'Exafunction/codeium.nvim',
  enabled = os.getenv('NVIM_ENABLE_AI') == '1',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  lazy = false,
  config = function() require('codeium').setup({}) end,
}

return plugin
