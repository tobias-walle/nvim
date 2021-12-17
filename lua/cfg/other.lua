-- Hop
require'hop'.setup {}

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup {enable_moveright = false}

-- Trouble
require('trouble').setup {}

-- Which key
require('which-key').setup {}

-- Gitsigns
require('gitsigns').setup {}

-- Telescope
require('telescope').setup {pickers = {find_files = {hidden = true}}}

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  sync_install = false,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false
  }
}

