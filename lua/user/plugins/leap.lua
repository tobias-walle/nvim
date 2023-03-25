---@type LazyPlugin
local plugin = {
  'ggandor/leap.nvim',
  config = function()
    require('leap').setup()
  end,
  keys = {
    { '<CR>', '<Plug>(leap-forward-to)', mode = { 'n', 'v' }, desc = 'Leap Forward' },
    { '<S-CR>', '<Plug>(leap-backward-to)', mode = { 'n', 'v' }, desc = 'Leap Backward' },
  },
}

return plugin
