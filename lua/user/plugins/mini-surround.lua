---@type LazySpec
local plugin = {
  'echasnovski/mini.surround',
  lazy = false,
  config = function()
    require('mini.surround').setup({
      search_method = 'cover',
      n_lines = 10000,
      mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'sF',
        highlight = 'sh',
        replace = 'sr',
        update_n_lines = 'sn',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    })
  end,
}

return plugin
