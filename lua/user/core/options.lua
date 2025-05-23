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
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.mouse = 'a'
opt.cursorline = true
opt.autoread = true
opt.shortmess = opt.shortmess + 'c'
opt.shell = 'fish'
opt.conceallevel = 0
opt.exrc = true

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

-- Folding configuration
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Enable the display of whitespace characters
opt.list = true
---@diagnostic disable-next-line: missing-fields
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·', -- Show trailing spaces as dots
  nbsp = '␣', -- Character to represent non-breaking spaces
}

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
    -- Disable autocomments
    vim.opt.formatoptions:remove('o')
  end,
})

-- Fix .env files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.env.*',
  callback = function() vim.bo.filetype = 'sh' end,
})

-- Allow comments in json files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.json',
  callback = function() vim.bo.filetype = 'jsonc' end,
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

vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
  },
})

-- Init some utils
require('user.utils.autoclose-unused-buffers').setup()
