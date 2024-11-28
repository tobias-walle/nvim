---@type LazySpec
local plugin = {
  'echasnovski/mini.test',
  version = '*',
  lazy = false,
  config = function()
    local test = require('mini.test')
    test.setup({})
    vim.api.nvim_create_user_command(
      'Test',
      function() require('mini.test').run_file(vim.fn.expand('%')) end,
      {}
    )
    vim.api.nvim_create_user_command(
      'TestAll',
      function() require('mini.test').run() end,
      {}
    )
  end,
  cmd = { 'Test' },
}

return plugin
