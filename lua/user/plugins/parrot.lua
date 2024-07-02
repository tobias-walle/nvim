---@type LazySpec
local plugin = {
  'frankroeder/parrot.nvim',
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  config = function()
    require('parrot').setup({
      providers = {
        pplx = {
          api_key = os.getenv('PERPLEXITY_API_KEY'),
        },
        openai = {
          api_key = os.getenv('OPENAI_API_KEY'),
        },
        anthropic = {
          api_key = os.getenv('ANTHROPIC_API_KEY'),
        },
        mistral = {
          api_key = os.getenv('MISTRAL_API_KEY'),
        },
      },
      hooks = {
        ProofRead = function(prt, params)
          local template = [[
          Correct the text in triple quotes below by fixing the grammar, punctuation and typos.
          Make your best effort.

          """
          {{selection}}
          """

          Do not return anything other than the corrected text. Do not wrap responses in quotes. Preserve all whitespace.
          ]]
          local agent = prt.get_command_agent()
          prt.logger.info('Proofreading selection with agent: ' .. agent.name)
          prt.Prompt(
            params,
            prt.ui.Target.rewrite,
            nil, -- command will run directly without any prompting for user input
            agent.model,
            template,
            agent.system_prompt,
            agent.provider
          )
        end,
      },
    })
  end,
}

return plugin
