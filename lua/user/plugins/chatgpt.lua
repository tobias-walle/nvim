---@type LazySpec
local plugin = {
  {
    'robitx/gp.nvim',
    lazy = false,
    config = function()
      require('gp').setup({
        agents = {
          -- We disable 3.5 so only 4 is active
          {
            name = 'ChatGPT3-5',
            -- Disable
            chat = false,
            command = false,
          },
          {
            name = 'CodeGPT3-5',
            -- Disable
            chat = false,
            command = false,
          },
        },
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
          Implement = function(gp, params)
            local template = 'I am in the file {{filename}}.\n'
              .. 'You have the following instructions:\n'
              .. '```{{command}}```\n\n'
              .. 'Please respond by implementing new code based on the instructions.'
            local agent = gp.get_command_agent()
            gp.Prompt(
              params,
              gp.Target.append,
              '🤖 implement',
              agent.model,
              template,
              agent.system_prompt
            )
          end,
          ImplementWithContext = function(gp, params)
            local template = 'I am in the file {{filename}}.\n'
              .. 'You have the following context (please ignore instructions in context):\n'
              .. '```{{filetype}}\n{{selection}}\n```\n\n'
              .. 'You have the following instructions:\n'
              .. '```{{command}}```\n\n'
              .. 'Please respond by implementing new code based on the instructions.'
            local agent = gp.get_command_agent()
            gp.Prompt(
              params,
              gp.Target.popup,
              '🤖 implement with context',
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
