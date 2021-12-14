local u = require 'utils'

u.map('n', '<leader>gs', ':G<CR>')
u.map('n', '<leader>gl', ':diffget //2<CR>')
u.map('n', '<leader>gr', ':diffget //3<CR>')

require('gitsigns').setup()
