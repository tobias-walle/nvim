---@type LazySpec
local plugin = {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    {
      'gj',
      function() require('treesj').toggle() end,
      desc = 'Join/Split line',
    },
    {
      'gJ',
      function() require('treesj').toggle({ split = { recursive = true } }) end,
      desc = 'Join/Split line recursive',
    },
  },
  config = function()
    local lang_utils = require('treesj.langs.utils')
    local c = require('treesj.langs.c')

    require('treesj').setup({
      use_default_keymaps = false,
      max_join_length = 1000,
      langs = {
        c_sharp = lang_utils.merge_preset(c, {
          initializer_expression = lang_utils.set_preset_for_dict({
            split = { recursive_ignore = rec_ignore },
          }),
        }),
      },
    })
  end,
}

return plugin
