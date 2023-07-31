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
      require('gitsigns').setup()
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

      local function prefer_local()
        vim.cmd.MergetoolPreferLocal()
        vim.g.mergetool_layout = 'mr'
        vim.cmd.MergetoolToggleLayout('mr')
      end

      local function prefer_remote()
        vim.cmd.MergetoolPreferRemote()
        vim.g.mergetool_layout = 'ml'
        vim.cmd.MergetoolToggleLayout('ml')
      end

      require('which-key').register({
        ['<leader>m'] = {
          name = 'Git Merge',
          l = {
            name = 'Layout',
            a = { ':MergetoolToggleLayout lmr<cr>', 'Toggle lmr layout' },
            A = { ':MergetoolToggleLayout LmR<cr>', 'Toggle LmR layout' },
            b = { ':MergetoolToggleLayout blr,m<cr>', 'Toggle blr,m layout' },
            B = { ':MergetoolToggleLayout BLR,m<cr>', 'Toggle blr,m layout' },
          },
          p = {
            name = 'Preference',
            l = { prefer_local, 'Prefer local revision' },
            r = { prefer_remote, 'Prefer remote revision' },
          },
        },
      })
    end,
  },
}

return plugin
