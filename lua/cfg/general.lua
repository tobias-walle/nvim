local u = require 'utils'

-- Options
vim.opt.encoding = 'utf-8'
vim.opt.hidden = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.pastetoggle = '<F2>'
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300

-- Disable autocomments
vim.cmd 'autocmd BufNewFile,BufWinEnter * setlocal formatoptions-=cro'

-- Tabs
vim.opt.showtabline = 2
u.map('n', 'th', ':tabprev<CR>')
u.map('n', 'tl', ':tabnext<CR>')
u.map('n', 'te', ':tabnew<CR>')
u.map('n', 'tc', ':tabclose<CR>')

-- Copy/Pasta
u.map('v', '<Leader>y', '"+y')

-- Pane Switching
u.map('n', '<C-j>', '<C-W>j')
u.map('n', '<C-k>', '<C-W>k')
u.map('n', '<C-h>', '<C-W>h')
u.map('n', '<C-l>', '<C-W>l')

