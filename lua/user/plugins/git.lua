---@type LazySpec
local plugin = {
  {
    'TimUntersberger/neogit',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('neogit').setup({
        kind = 'replace',
        integrations = {
          diffview = true,
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({ keymaps = {} })
    end,
  },
  {
    'samoshkin/vim-mergetool',
    lazy = true,
    config = function()
      vim.g.mergetool_layout = 'mr'
      vim.g.mergetool_prefer_revision = 'local'
    end,
    cmd = { 'MergetoolStart', 'MergetoolToggle' },
  },
}

return plugin
