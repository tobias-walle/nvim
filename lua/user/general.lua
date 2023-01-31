-- Options
vim.o.encoding = 'utf-8'
vim.o.hidden = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.copyindent = true
vim.o.smartindent = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.pastetoggle = '<F2>'
vim.o.cursorline = true
vim.o.autoread = true
vim.opt.shortmess = vim.opt.shortmess + 'c'

vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 50
vim.o.timeoutlen = 500
vim.wo.signcolumn = 'yes'
vim.o.scrolloff = 15
vim.o.showtabline = 1
vim.o.undofile = true
vim.o.guifont = 'JetBrainsMono Nerd Font'
vim.opt.spelllang = 'en,de'
vim.o.spell = true
vim.o.spellcapcheck = false

-- see https://github.com/sindrets/diffview.nvim/issues/35
vim.opt.fillchars = vim.opt.fillchars + 'diff:╱'

vim.cmd([[set formatoptions-=o]])
local general_options_au_group = vim.api.nvim_create_augroup('general_options', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter' }, {
  pattern = '*',
  group = general_options_au_group,
  callback = function()
    -- Folding
    vim.o.foldlevelstart = 99
    vim.o.foldmethod = 'indent'
    vim.o.foldenable = false
    -- Disable autocomments
    vim.cmd([[setlocal formatoptions-=o]])
  end,
})

-- Check for changes on focus/buffer enter
local checktime_au_group = vim.api.nvim_create_augroup('checktime', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  group = checktime_au_group,
  callback = function()
    vim.cmd.checktime()
  end,
})
