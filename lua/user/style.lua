-- Themes
require('tokyonight').setup({ style = 'night', sidebars = { 'fern', 'packer' } })
vim.cmd([[colorscheme tokyonight]])
vim.cmd([[hi LspInlayHint guifg=#4d7a80 guibg=#1f2335]])

-- UI
require('dressing').setup({})

-- Tabs
require('luatab').setup({})

-- Lualine
require('lualine').setup({
  options = { theme = 'tokyonight', globalstatus = true },
  sections = {
    lualine_a = { { 'filename', file_status = true, path = 1 } },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
  },
})

-- Scrollbar
require('scrollbar').setup({})
