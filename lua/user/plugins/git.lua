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
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({ keymaps = {} })
    end,
  },
  {
    'samoshkin/vim-mergetool',
    lazy = true,
    cmd = { 'MergetoolStart', 'MergetoolToggle' },
    keys = {
      { '<leader>mt', ':MergetoolToggle<cr>', desc = 'Toggle Mergetool' },
    },
    config = function()
      vim.g.mergetool_layout = 'mr'
      vim.g.mergetool_prefer_revision = 'local'

      require('which-key').register({
        ['<leader>m'] = {
          name = 'Git Merge',
          l = {
            name = 'Layout',
            a = { ':MergetoolToggleLayout lmr<cr>', 'Toggle lmr layout' },
            b = { ':MergetoolToggleLayout blr,m<cr>', 'Toggle blr,m layout' },
          },
          p = {
            name = 'Preference',
            l = { ':MergetoolPreferLocal<cr>', 'Prefer local revision' },
            r = { ':MergetoolPreferRemote<cr>', 'Prefer remote revision' },
          },
        },
      })
    end,
  },
}

return plugin
