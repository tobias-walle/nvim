---@type LazySpec
local plugin = {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
  },
  event = 'BufEnter',
  config = function()
    require('codecompanion').setup({
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
        agent = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            model = {
              default = 'claude-3-5-sonnet-20241022',
            },
            env = {
              api_key = os.getenv('ANTHROPIC_API_KEY'),
            },
          })
        end,
      },
    })
  end,
}

return plugin
