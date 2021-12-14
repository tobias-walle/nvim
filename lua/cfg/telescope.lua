local u = require 'utils'

u.map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
u.map('n', '<C-f>', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
u.map('n', '<C-c>', '<cmd>lua require("telescope.builtin").commands()<cr>')
u.map('n', '<C-b>', '<cmd>lua require("telescope.builtin").buffers()<cr>')

require('telescope').setup {}
