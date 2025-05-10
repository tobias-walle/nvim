---@type LazySpec
local plugin = {
  'tobias-walle/ai.nvim',
  dir = '~/Projects/ai.nvim',
  enabled = true,
  event = 'BufEnter',
  config = function()
    local default_models = {
      default = 'azure:gpt-4.1',
      mini = 'azure:gpt-4.1-mini',
      nano = 'azure:gpt-4.1-nano',
      thinking = 'azure:o4-mini',
    }
    require('ai').setup({
      default_models = default_models,
      selectable_models = { default_models },
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
