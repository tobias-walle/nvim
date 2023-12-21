---@type LazySpec
local plugin = {
  -- Paste Images
  'ekickx/clipboard-image.nvim',
  lazy = false,
  config = function()
    require('clipboard-image').setup({
      default = {
        img_dir = { '%:p:h', 'media' },
        img_dir_txt = 'media',
        img_name = function() return vim.fn.input('Image Filename: ') end,
      },
    })
  end,
}

return plugin
