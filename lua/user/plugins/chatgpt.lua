---@type LazySpec
local plugin = {
  {
    'robitx/gp.nvim',
    event = 'VeryLazy',
    config = function()
      require('gp').setup({
        hooks = {
          UnitTests = function(gp, params)
            local template = 'I have the following code from {{filename}}:\n\n'
              .. '```{{filetype}}\n{{selection}}\n```\n\n'
              .. 'Please respond by writing table driven unit tests for the code above.'
            local agent = gp.get_command_agent()
            gp.Prompt(
              params,
              gp.Target.append,
              nil,
              agent.model,
              template,
              agent.system_prompt
            )
          end,
          Explain = function(gp, params)
            local template = 'I have the following code from {{filename}}:\n\n'
              .. '```{{filetype}}\n{{selection}}\n```\n\n'
              .. 'Please respond by explaining the code above.'
            local agent = gp.get_chat_agent()
            gp.Prompt(
              params,
              gp.Target.popup,
              nil,
              agent.model,
              template,
              agent.system_prompt
            )
          end,
        },
      })
    end,
  },
}

return plugin
