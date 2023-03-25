---@type LazyPlugin
local plugin = {
  -- Custom surround text objects for example to replace text in ``
  'echasnovski/mini.ai',
  config = function()
    local ai = require('mini.ai')
    require('mini.ai').setup({
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }, {}),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
      },
    })
  end,
}

return plugin
