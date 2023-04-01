---@type LazySpec
local plugin = {
  'ggandor/leap.nvim',
  config = function()
    require('leap').setup()
  end,
  keys = {
    { 's', '<Plug>(leap-forward-to)', mode = { 'n', 'v' }, desc = 'Leap Forward' },
    { 'S', '<Plug>(leap-backward-to)', mode = { 'n', 'v' }, desc = 'Leap Backward' },
  },
}

return plugin
