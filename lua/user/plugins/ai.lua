---@type LazySpec
local plugin = {
  'tobias-walle/ai.nvim',
  dir = '~/Projects/ai.nvim',
  enabled = true,
  event = 'BufEnter',
  config = function()
    require('ai').setup({
      -- default_model = 'anthropic',
      -- default_model = 'openrouter:deepseek/deepseek-chat',
      -- default_model = 'openrouter:qwen/qwen-2.5-coder-32b-instruct',
      -- default_model = 'ollama:qwen2.5-coder:32b',
      default_model = 'azure:gpt-4o',
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
