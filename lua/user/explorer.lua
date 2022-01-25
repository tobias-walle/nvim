vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#default_hidden'] = true

vim.cmd [[ 
function! FernInit() abort
  augroup FernGroupLocal
    autocmd! * <buffer>
    autocmd BufEnter <buffer> silent execute "normal \<Plug>(fern-action-reload)"
  augroup END
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END
]]

