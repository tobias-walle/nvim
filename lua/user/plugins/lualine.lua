---@return LazyConfig
return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup({
      options = { theme = 'tokyonight', globalstatus = true },
      sections = {
        lualine_a = { { 'filename', file_status = true, path = 1 } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
      },
    })
  end,
}
