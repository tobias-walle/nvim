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
            normal_hl = 'Comment',
            winblend = 0,
            zindex = 100,
          },
        },
      })
    end,
  },
}

return plugin
