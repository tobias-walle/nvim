---@type LazyPlugin
local plugin = {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({ keymaps = {} })
    end,
  },
  {
    'tpope/vim-fugitive',
    config = function() end,
  },
  {
    'samoshkin/vim-mergetool',
    config = function()
      vim.g.mergetool_layout = 'mr'
      vim.g.mergetool_prefer_revision = 'local'
    end,
  },
}

return plugin
