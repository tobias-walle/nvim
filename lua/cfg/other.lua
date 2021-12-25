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

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Telescope
require('telescope').setup {
  defaults = {file_ignore_patterns = {'.git/'}},
  pickers = {find_files = {hidden = true}}
}

-- Neoclip
require('neoclip').setup {}

-- Cargo Toml
vim.cmd [[ autocmd BufRead Cargo.toml call crates#toggle() ]]

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  sync_install = false,
  highlight = {enable = true, disable = {}, additional_vim_regex_highlighting = false}
}

