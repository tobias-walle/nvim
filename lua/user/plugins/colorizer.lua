---@type LazyPlugin
local plugin = {
  -- Autoclose brackets
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        -- Available modes for `mode`: foreground, background, virtualtext
        mode = 'background', -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        tailwind = 'lsp',
        -- update color values even if buffer is not focused
        always_update = false,
      },
    })
  end,
}

return plugin
