---@type LazyPlugin
local plugin = {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({ style = 'night', sidebars = { 'fern', 'packer' } })
    vim.cmd([[
    colorscheme tokyonight

    hi LspInlayHint guifg=#4d7a80 guibg=#1f2335
    hi SpellBad cterm=undercurl gui=undercurl guisp=#BA5AF1
    hi SpellCap cterm=undercurl gui=undercurl guisp=#839EEE
    hi SpellLocal cterm=undercurl gui=undercurl guisp=#839EEE
    hi SpellRare cterm=undercurl gui=undercurl guisp=#839EEE
    ]])
  end,
}

return plugin
