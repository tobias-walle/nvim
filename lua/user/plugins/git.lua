---@type LazySpec
local plugin = {
  {
    'tpope/vim-fugitive',
    enabled = true,
    event = 'VeryLazy',
    cmd = { 'G' },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function() require('gitsigns').setup() end,
  },
  {
    'samoshkin/vim-mergetool',
    cmd = { 'MergetoolStart', 'MergetoolToggle' },
  },
}

return plugin
