---@type LazySpec
local plugin = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'AckslD/nvim-neoclip.lua',
    'aaronhallaert/advanced-git-search.nvim',
  },
  config = function()
    local lga_actions = require('telescope-live-grep-args.actions')

    require('telescope').setup({
      defaults = {
        file_ignore_patterns = { '.git/', 'yarn.lock', 'pnpm-lock.yaml', '.yarn/', 'node_modules/', 'dist/' },
        layout_strategy = 'vertical',
        layout_config = { vertical = { width = 0.9 } },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--hidden',
          },
        },
      },
      extensions = {
        live_grep_args = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--hidden',
          },
          auto_quoting = true,
          mappings = {
            i = { ['<C-k>'] = lga_actions.quote_prompt() },
          },
        },
        file_browser = {
          hijack_netrw = false,
          hidden = true,
          respect_gitignore = false,
        },
        advanced_git_search = {
          -- fugitive or diffview
          diff_plugin = 'fugitive',
          git_flags = { '--no-pager', '-c', 'delta.side-by-side=false' },
          git_diff_flags = {},
          show_builtin_git_pickers = false,
        },
      },
    })

    require('telescope').load_extension('live_grep_args')
    require('telescope').load_extension('file_browser')
    require('telescope').load_extension('neoclip')
    require('telescope').load_extension('advanced_git_search')
  end,
}

return plugin
