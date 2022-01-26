-- Hop
require'hop'.setup {}

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup {enable_moveright = false}

-- Autotags
require'nvim-ts-autotag'.setup {}

-- Trouble
require('trouble').setup {}

-- Which key
require('which-key').setup {}

-- Gitsigns
require('gitsigns').setup {keymaps = {}}

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Project Nvim
require('project_nvim').setup {}
require('telescope').load_extension('projects')

-- Neoclip
require('neoclip').setup {}

-- Cargo Toml
vim.cmd [[ autocmd BufRead Cargo.toml call crates#toggle() ]]

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  sync_install = false,
  highlight = {enable = true, disable = {}, additional_vim_regex_highlighting = false},
  indent = {enable = true}
}

-- Luasnip
require('luasnip.loaders.from_snipmate').load()
