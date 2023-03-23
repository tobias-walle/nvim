-- Options
vim.opt.encoding = 'utf-8'
vim.opt.hidden = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.number = true
-- vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.pastetoggle = '<F2>'
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.shortmess = vim.opt.shortmess + 'c'

vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 50
vim.o.timeoutlen = 500
vim.wo.signcolumn = 'yes'
vim.o.scrolloff = 15
vim.o.showtabline = 1
vim.o.guifont = 'JetBrainsMono Nerd Font'
vim.opt.spelllang = 'en,de'
vim.o.spell = true
vim.o.spellcapcheck = false

vim.opt.undofile = true

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
