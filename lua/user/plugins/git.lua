---@type LazySpec
local plugin = {
  {
    'NeogitOrg/neogit',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({})
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function() require('gitsigns').setup() end,
  },
  {
    'samoshkin/vim-mergetool',
    cmd = { 'MergetoolStart', 'MergetoolToggle' },
  },
}

return plugin
