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
        default = 'anthropic:claude-3-7-sonnet-latest',
      } or {
        default = 'azure:gpt-4o',
        mini = 'azure:gpt-4o-mini',
      },
      selectable_models = {
        { default = 'openai:gpt-4o', mini = 'openai:gpt-4o-mini' },
        { default = 'azure:gpt-4o', mini = 'azure:gpt-4o-mini' },
        { default = 'azure:gpt-4o' },
        { default = 'azure:o3-mini' },
        { default = 'anthropic:claude-3-7-sonnet-latest' },
        { default = 'openrouter:deepseek/deepseek-chat-v3-0324' },
        { default = 'openrouter:google/gemini-2.5-pro-preview-03-25' },
        { default = 'ollama:mistral-small:24b' },
        { default = 'ollama:qwen2.5-coder:32b' },
        { default = 'ollama:qwen2.5-coder:7b' },
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
