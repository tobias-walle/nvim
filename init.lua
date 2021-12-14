require 'general'
require 'plugins'
require 'plugin-config'

vim.cmd [[
source $HOME/.config/nvim/cfg/explorer.vim
source $HOME/.config/nvim/cfg/telescope.vim
source $HOME/.config/nvim/cfg/git.vim
]]

-- Themes
require'onedark'.setup()

-- Lualine
require'lualine'.setup {options = {theme = 'onedark'}}
