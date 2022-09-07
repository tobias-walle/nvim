-- Themes
require('tokyonight').setup {style = 'night', sidebars = {'fern', 'packer'}}
vim.cmd [[colorscheme tokyonight]]
vim.cmd [[hi LspInlayHint guifg=#4d7a80 guibg=#1f2335]]

-- UI
require'dressing'.setup {}

-- Tabs
require'luatab'.setup {}

-- Lualine
require'lualine'.setup {
  options = {theme = 'tokyonight'},
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', file_status = true, path = 1}},
    lualine_x = {},
    lualine_y = {}
  }
}

-- Scrollbar
require('scrollbar').setup {}
