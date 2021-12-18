local function highlight(o)
  local fg = o.fg and 'guifg=' .. o.fg or 'guifg=NONE'
  local bg = o.bg and 'guibg=' .. o.bg or 'guibg=NONE'
  local sp = o.sp and 'guisp=' .. o.sp or 'guisp=NONE'
  vim.cmd('highlight ' .. o[1] .. ' ' .. fg .. ' ' .. bg .. ' ' .. sp)
end

-- Themes
require'onedark'.setup()
highlight {'TabLine', fg = '#5a6270', bg = '#1b1e24'}
highlight {'TabLineFill', bg = '#1b1e24'}
highlight {'TabLineSel', fg = '#c3ccdb', bg = '#1b1e24'}

-- Tabs
require'luatab'.setup {}

-- Lualine
require'lualine'.setup {
  options = {theme = 'onedark'},
  sections = {lualine_c = {{'filename', file_status = true, path = 1}}}
}
