local M = {}

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
  },
})

require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('neoclip')
require('telescope').load_extension('file_browser')

function M.find_files_all()
  require('telescope.builtin').find_files({ no_ignore = true })
end

function M.live_grep_all()
  require('telescope').extensions.live_grep_args.live_grep_args({
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--hidden',
      '--no-ignore',
    },
  })
end

function M.live_grep()
  require('telescope').extensions.live_grep_args.live_grep_args()
end

return M
