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
vim.opt.autoread = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 15
vim.opt.showtabline = 1
vim.opt.undofile = true
vim.opt.guifont = 'JetBrainsMono Nerd Font'
-- see https://github.com/sindrets/diffview.nvim/issues/35
vim.opt.fillchars = vim.opt.fillchars + 'diff:╱'

local general_options_au_group = vim.api.nvim_create_augroup('general_options', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter' }, {
  pattern = '*',
  group = general_options_au_group,
  callback = function()
    -- Folding
    vim.opt_local.foldlevelstart = 99
    vim.opt_local.foldmethod = 'indent'
    vim.opt_local.foldenable = false
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
    vim.api.nvim_command('checktime')
  end,
})
