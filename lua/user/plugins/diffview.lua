---@type LazySpec
local plugin = {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  config = function() require('diffview').setup({}) end,
}

return plugin
