local u = require 'utils'

-- Hop
require'hop'.setup()
u.map('n', 's', ':HopWord<CR>')

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup {enable_moveright = false, ignored_next_char = '%S'}

-- Other
require 'cfg.treesitter'
require 'cfg.completion'
require 'cfg.explorer'
require 'cfg.telescope'
require 'cfg.git'
