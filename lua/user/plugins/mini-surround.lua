---@type LazySpec
local plugin = {
  'echasnovski/mini.surround',
  event = 'VeryLazy',
  config = function()
    require('mini.surround').setup({
      search_method = 'cover',
      n_lines = 10000,
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    })
  end,
}

return plugin
