---@type LazySpec
local plugin = {
  'tobias-walle/ai.nvim',
  dir = '~/Projects/ai.nvim',
  enabled = true,
  event = 'BufEnter',
  config = function()
    local use_insecure_models = os.getenv('AI_NVIM_INSECURE_MODELS') == 'true'
      or vim.g.use_insecure_models == true
    require('ai').setup({
      default_models = use_insecure_models and {
        default = 'openrouter:deepseek/deepseek-chat',
      } or {
        default = 'azure:gpt-4o',
        mini = 'azure:gpt-4o-mini',
      },
      selectable_models = {
        { default = 'openai:gpt-4o', mini = 'openai:gpt-4o-mini' },
        { default = 'azure:gpt-4o', mini = 'azure:gpt-4o-mini' },
        {
          default = 'anthropic:claude-3-5-sonnet-20241022',
          mini = 'anthropic:claude-3-5-haiku-20241022',
        },
        { default = 'openrouter:deepseek/deepseek-chat' },
        { default = 'ollama:qwen2.5-coder:32b' },
      },
    })

    -- Reload for development
    vim.keymap.set(
      'n',
      ',r',
      function() require('lazy').reload({ plugins = { 'ai.nvim' } }) end
    )
  end,
  -- keys = {
  --   { '<C-x>', function() require('ai').trigger_completion() end, mode = 'i', desc = 'Trigger Ai Completion' },
  --   { '<Leader>aa', '<cmd>AiChat<cr>', mode = 'n', desc = 'Toggle AI Chat' },
  --   { '<Leader>ar', '<cmd>AiRewrite<cr>', mode = 'v', desc = 'Rewrite Selected Text' },
  --   { '<Leader>am', '<cmd>AiChangeModels<cr>', mode = 'n', desc = 'Change AI Models' },
  -- },
}

return plugin
