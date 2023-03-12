-- Custom surround text objects for example to replace text in ``
require('mini.ai').setup({})
-- Jump to last buffer if a buffer gets remove
require('mini.bufremove').setup({})
-- Comment
require('mini.comment').setup({
  hooks = {
    pre = function()
      require('ts_context_commentstring.internal').update_commentstring()
    end,
  },
})
-- Highlight word under cursor
-- require('mini.cursorword').setup({})
-- Highlight scope
-- require('mini.indentscope').setup({
--   draw = {
--     animation = require('mini.indentscope').gen_animation.none(),
--   },
-- })
