local M = {}

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {'.git/', 'yarn.lock', '.yarn'},
    layout_strategy = 'vertical',
    layout_config = {vertical = {width = 0.9}}
  },
  pickers = {
    find_files = {hidden = true},
    live_grep = {
      vimgrep_arguments = {
        'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
        '--hidden'
      }
    }
  }
}

function M.find_files_all() require('telescope.builtin').find_files({no_ignore = true}) end

function M.live_grep_all()
  require('telescope.builtin').live_grep({
    vimgrep_arguments = {
      'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
      '--hidden', '--no-ignore'
    }
  })
end

return M
