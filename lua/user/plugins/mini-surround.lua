---@type LazyPlugin
local plugin = {
  'echasnovski/mini.surround',
  config = function()
    require('mini.surround').setup({
      search_method = 'cover_or_next',
    })
  end,
}

return plugin
