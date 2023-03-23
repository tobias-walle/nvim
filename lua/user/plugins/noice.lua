---@return LazyConfig
return {
  'folke/noice.nvim',
  config = function()
    require('noice').setup({
      presets = {
        bottom_search = true,
      },
      messages = {
        enabled = false, -- enables the Noice messages UI
      },
      cmdline = {
        ---@type table<string, CmdlineFormat>
        format = {
          cmdline = { pattern = '^:', icon = '', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = '', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
          lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          input = {},
        },
      },
    })
  end,
}
