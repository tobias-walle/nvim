---@type LazySpec
local plugin = {
  {
    'TimUntersberger/neogit',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    keys = {
      {
        '<leader>gs',
        function()
          require('neogit').open()
        end,
        desc = 'Git Status',
      },
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
    'tpope/vim-fugitive',
    enabled = true,
    event = 'VeryLazy',
    cmd = { 'G' },
    keys = {
      { '<leader>gs', '<cmd>G<cr><cmd>only<cr>', desc = 'Git Status' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({ keymaps = {} })
    end,
  },
  {
    'samoshkin/vim-mergetool',
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
