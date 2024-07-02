---@type LazySpec
local plugin = {
  -- Autoclose brackets
  'windwp/nvim-autopairs',
  enabled = false,
  event = 'VeryLazy',
  config = function()
    require('nvim-autopairs').setup({
      enable_moveright = true,
      fast_wrap = {},
    })
  end,
}

return plugin
