---@type LazySpec
local plugin = {
  'tobias-walle/ai.nvim',
  dir = '~/Projects/ai.nvim',
  enabled = true,
  event = 'BufEnter',
  config = function()
    require('ai').setup({
      default_model = 'azure:gpt-4o',
      chat = {
        model = 'azure:gpt-4o',
      },
      command = {
        model = 'azure:gpt-4o',
      },
      completion = {
        model = 'azure:gpt-4o-mini',
      },
    })

    -- Reload for development
    vim.keymap.set(
      'n',
      ',r',
      function() require('lazy').reload({ plugins = { 'ai.nvim' } }) end
    )
  end,
}

return plugin
