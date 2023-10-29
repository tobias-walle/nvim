local M = {}

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
