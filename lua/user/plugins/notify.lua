---@type LazySpec
local plugin = {
  'rcarriga/nvim-notify',
  lazy = false,
  config = function()
    -- Setup
    require('notify').setup({
      background_colour = 'NotifyBackground',
      fps = 30,
      icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
      },
      level = 2,
      minimum_width = 50,
      max_width = 100,
      timeout = 3000,
      render = 'default',
      stages = 'static',
    })
  end,
}

return plugin
