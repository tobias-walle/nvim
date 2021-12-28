local M = {}

function M.find_files_all()
  require("telescope.builtin").find_files({
    no_ignore = true
  })
end

function M.live_grep_all()
  require("telescope.builtin").live_grep({
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--no-ignore' -- thats the new thing
    },
  })
end

return M
