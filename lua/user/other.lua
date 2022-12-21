-- Hop
require('hop').setup({})

-- Which key
require('which-key').setup({})

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Neoclip
require('neoclip').setup({})

-- Neoterm
vim.g.neoterm_default_mod = 'belowright'

-- Undotree
vim.g.mundo_width = 45
vim.g.mundo_preview_height = 30
vim.g.mundo_preview_height = 30
vim.g.mundo_preview_bottom = true

-- Aerial (Outline)
require('aerial').setup()

-- Comments
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Colors
require('colorizer').setup()
