---@type LazySpec
local plugins = {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
      'kristijanhusak/vim-dadbod-completion',
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function() vim.g.db_ui_use_nerd_fonts = 1 end,
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          require('cmp').setup.buffer({
            sources = {
              { name = 'vim-dadbod-completion' },
              { name = 'buffer' },
            },
          })
        end,
      })
    end,
  },
}

return plugins
