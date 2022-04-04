-- Themes
vim.g.tokyonight_style = 'night'
vim.g.tokyonight_sidebars = {'fern', 'packer'}
vim.cmd [[colorscheme tokyonight]]

-- Tabs
require'luatab'.setup {}

-- Lualine
require'lualine'.setup {
  options = {theme = 'tokyonight'},
  sections = {lualine_c = {{'filename', file_status = true, path = 1}}}
}

-- Scrollbar
require('scrollbar').setup {}
