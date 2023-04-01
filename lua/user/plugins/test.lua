---@type LazySpec
local plugin = {
  'vim-test/vim-test',
  event = 'VeryLazy',
  build = function()
    pcall(function()
      vim.cmd([[UpdateRemotePlugins]])
    end)
  end,
  config = function()
    vim.g['test#strategy'] = 'neoterm'

    local configureJSTest = function()
      vim.g['test#javascript#jest#executable'] = 'yarn test'
      vim.g['test#javascript#runner'] = 'jest'
      -- vim.g['test#project_root'] = vim.fn.expand('%:p:h')
    end

    local test_au_group = vim.api.nvim_create_augroup('test', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      pattern = '*.tsx,*.ts,*.js,*.jsx',
      group = test_au_group,
      callback = configureJSTest,
    })
  end,
}

return plugin
