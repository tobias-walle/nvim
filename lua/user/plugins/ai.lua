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
