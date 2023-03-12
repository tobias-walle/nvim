-- Themes
require('tokyonight').setup({ style = 'night', sidebars = { 'fern', 'packer' } })
vim.cmd([[
colorscheme tokyonight

hi LspInlayHint guifg=#4d7a80 guibg=#1f2335
hi SpellBad cterm=undercurl gui=undercurl guisp=#BA5AF1
hi SpellCap cterm=undercurl gui=undercurl guisp=#839EEE
hi SpellLocal cterm=undercurl gui=undercurl guisp=#839EEE
hi SpellRare cterm=undercurl gui=undercurl guisp=#839EEE
]])

-- UI
require('dressing').setup({
  input = { insert_only = false },
})
-- require('notify').setup({
--   render = 'minimal',
--   stages = 'fade',
--   timeout = 2000,
--   top_down = false,
-- })
require('noice').setup({
  presets = {
    bottom_search = true,
  },
  messages = {
    enabled = false, -- enables the Noice messages UI
  },
  cmdline = {
    ---@type table<string, CmdlineFormat>
    format = {
      cmdline = { pattern = '^:', icon = '', lang = 'vim' },
      search_down = { kind = 'search', pattern = '^/', icon = '', lang = 'regex' },
      search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
      filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
      lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
      help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
      input = {},
    },
  },
})

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
