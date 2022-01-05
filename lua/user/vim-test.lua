vim.g.ultest_use_pty = 1

_G.configureJestTest = function()
	vim.g['test#javascript#jest#executable'] = "yarn jest"
	vim.g['test#javascript#runner'] = "jest"
	vim.g['test#project_root'] = vim.fn.expand('%:p:h')
end

vim.cmd([[
  augroup test
    autocmd!
    autocmd BufEnter *.tsx,*.ts,*.js,*.jsx call v:lua.configureJestTest()
  augroup END
]])
