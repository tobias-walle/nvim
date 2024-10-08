local opt = vim.opt

-- Options
opt.encoding = 'utf-8'
opt.hidden = true
opt.wrap = false
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smarttab = true
opt.expandtab = true
opt.number = true
opt.relativenumber = false
opt.signcolumn = 'yes'
opt.mouse = 'a'
opt.cursorline = true
opt.autoread = true
opt.shortmess = opt.shortmess + 'c'
opt.shell = 'fish'
opt.cmdheight = 2

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 50
opt.timeoutlen = 250
opt.scrolloff = 15
opt.showtabline = 1
opt.guifont = 'JetBrainsMono Nerd Font'
opt.spelllang = 'en,de'
opt.spell = true
opt.spellcapcheck = ''

opt.undofile = true

-- see https://github.com/sindrets/diffview.nvim/issues/35
opt.fillchars = opt.fillchars + 'diff:╱'

-- Do not let the editorconfig change the EOL style (Git is already managing that)
require('editorconfig').properties.end_of_line = nil

vim.cmd([[set formatoptions-=o]])
local general_options_au_group =
  vim.api.nvim_create_augroup('general_options', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter' }, {
  pattern = '*',
  group = general_options_au_group,
  callback = function()
    -- Folding
    vim.opt.foldlevelstart = 99
    vim.opt.foldmethod = 'indent'
    vim.opt.foldenable = false
    -- Disable autocomments
    vim.opt.formatoptions:remove('o')
  end,
})

-- Fix .env files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.env.*',
  callback = function() vim.bo.filetype = 'sh' end,
})

-- Check for changes on focus/buffer enter
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    if vim.fn.bufexists('[Command Line]') == 0 and vim.fn.mode() ~= 'c' then
      vim.cmd.checktime()
    end
  end,
})

-- Init some utils
require('user.utils.autoclose-unused-buffers').setup()
