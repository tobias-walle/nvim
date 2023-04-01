---@type LazySpec
local plugin = {
  -- Cargo.toml completion
  'saecki/crates.nvim',
  event = 'VeryLazy',
  config = function()
    require('crates').setup({
      null_ls = {
        enabled = true,
        name = 'crates.nvim',
      },
    })
  end,
}

return plugin
