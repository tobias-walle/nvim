---@type LazySpec
local plugin = {
  'folke/noice.nvim',
  lazy = false,
  dependencies = {
    'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup({
      presets = {
        lsp_doc_border = true,
      },
      cmdline = {
        format = {
          cmdline = {
            view = 'cmdline',
            pattern = '^:',
            icon = '',
            lang = 'vim',
          },
          search_down = {
            view = 'cmdline',
            kind = 'search',
            pattern = '^/',
            icon = '',
            lang = 'regex',
          },
          search_up = {
            view = 'cmdline',
            kind = 'search',
            pattern = '^%?',
            icon = ' ',
            lang = 'regex',
          },
          filter = {
            view = 'cmdline',
            pattern = '^:%s*!',
            icon = '$',
            lang = 'fish',
          },
          lua = {
            view = 'cmdline',
            pattern = '^:%s*lua%s+',
            icon = '',
            lang = 'lua',
          },
          help = {
            view = 'cmdline',
            pattern = '^:%s*he?l?p?%s+',
            icon = '?',
          },
          input = {},
        },
      },
    })
  end,
}

return plugin
