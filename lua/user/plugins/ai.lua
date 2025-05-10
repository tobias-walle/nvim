---@type LazySpec
local plugin = {
  'tobias-walle/ai.nvim',
  dir = '~/Projects/ai.nvim',
  enabled = true,
  event = 'BufEnter',
  config = function()
    require('ai').setup({
      default_models = {
        default = 'azure:gpt-4.1',
        mini = 'azure:gpt-4.1-nano',
        nano = 'azure:gpt-4.1-nano',
      },
      selectable_models = {
        {
          default = 'azure:gpt-4.1',
          mini = 'azure:gpt-4.1-mini',
          nano = 'azure:gpt-4.1-nano',
        },
        {
          default = 'azure:o4-mini',
          mini = 'azure:gpt-4.1-mini',
          nano = 'azure:gpt-4.1-nano',
        },
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
