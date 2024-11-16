---@type LazySpec
local plugin = {
  {
    'j-hui/fidget.nvim',
    lazy = false,
    config = function()
      require('fidget').setup({
        notification = {
          filter = vim.log.levels.DEBUG,
          history_size = 1000,
          override_vim_notify = true,
          window = {
            normal_hl = 'Normal', -- Base highlight group in the notification window
            winblend = 0, -- Background color opacity in the notification window
            zindex = 100, -- Stacking priority of the notification window
            max_width = 0, -- Maximum width of the notification window
            max_height = 0, -- Maximum height of the notification window
            x_padding = 1, -- Padding from right edge of window boundary
            y_padding = 0, -- Padding from bottom edge of window boundary
            align = 'bottom', -- How to align the notification window
            relative = 'editor', -- What the notification window position is relative to
          },
        },
      })
    end,
  },
}

return plugin
