local u = require 'utils'

-- Hop
require'hop'.setup()
u.map('n', 's', ':HopWord<CR>')

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup {enable_moveright = false}

-- Other
require 'treesitter'
require 'completion'
