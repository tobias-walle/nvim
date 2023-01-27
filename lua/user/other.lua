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
vim.g.undotree_WindowLayout = 2

-- Aerial (Outline)
require('aerial').setup()

-- Comments
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Colors
require('colorizer').setup()

-- Paste Images
require('clipboard-image').setup({
  default = {
    img_dir = 'media',
    img_dir_txt = 'media',
    img_name = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      return vim.fn.input('Image Filename: ')
    end,
  },
})
