vim.cmd [[
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_highlight_opened_files = 0
let g:nvim_tree_disable_window_picker = 0
let g:nvim_tree_icon_padding = ' '

let g:nvim_tree_special_files = { 
  \ 'README.md': 1, 
  \ 'package.json': 1, 
  \ 'cargo.toml': 1 
  \ }
let g:nvim_tree_show_icons = {
  \ 'git': 1,
  \ 'folders': 1,
  \ 'files': 1,
  \ 'folder_arrows': 1,
  \ }
]]

-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup {
  auto_close = true,
  git = {enable = true, ignore = false, timeout = 1000},
  view = {width = 40, height = 30, number = true, relativenumber = true},
  trash = {cmd = 'trash', require_confirm = true}
}
