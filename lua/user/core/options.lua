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

-- Enable the display of whitespace characters
opt.list = true
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·', -- Show trailing spaces as dots
  extends = '>', -- Character to show when text extends beyond the window
  precedes = '<', -- Character to show when text precedes the window
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
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = false
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
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

vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
  },
})

-- Init some utils
require('user.utils.autoclose-unused-buffers').setup()
