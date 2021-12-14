require 'utils'

require 'plugins'

-- General
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.pastetoggle = '<F2>'

-- Pane Switching
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')

-- Hop
require'hop'.setup()
nmap('s', ':HopWord<CR>')

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup()

-- External
require 'treesitter'
require 'completion'
vim.cmd [[
source $HOME/.config/nvim/cfg/explorer.vim
source $HOME/.config/nvim/cfg/telescope.vim
source $HOME/.config/nvim/cfg/git.vim
]]

-- Themes
require'onedark'.setup()

-- Lualine
require'lualine'.setup {options = {theme = 'onedark'}}
