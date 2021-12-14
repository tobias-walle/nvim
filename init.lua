require 'cfg.general'
require 'plugins'
require 'cfg.plugins'

-- Themes
require'onedark'.setup()

-- Lualine
require'lualine'.setup {options = {theme = 'onedark'}}
