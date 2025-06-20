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
      thinking = 'azure:o3',
    }
    local anthropic = {
      default = 'anthropic:claude-sonnet-4-0',
      mini = 'anthropic:claude-3-5-haiku-latest',
      nano = 'anthropic:claude-3-5-haiku-latest',
    }
    local ollama = {
      default = 'ollama:qwen3:4b',
    }
    require('ai').setup({
      default_models = default_models,
      selectable_models = { default_models, anthropic, ollama },
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
