local u = require 'utils'

-- Options
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.pastetoggle = '<F2>'

-- Copy/Pasta
u.map('v', '<Leader>y', '"+y')

-- Pane Switching
u.map('n', '<C-j>', '<C-W>j')
u.map('n', '<C-k>', '<C-W>k')
u.map('n', '<C-h>', '<C-W>h')
u.map('n', '<C-l>', '<C-W>l')

