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
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 15
vim.opt.showtabline = 2
vim.opt.guifont = 'JetBrainsMono Nerd Font'

-- Disable autocomments
vim.cmd 'autocmd BufNewFile,BufWinEnter * setlocal formatoptions-=cro'


