---@return LazyConfig
return {
  -- Cargo.toml completion
  'saecki/crates.nvim',
  config = function()
    require('crates').setup({
      null_ls = {
        enabled = true,
        name = 'crates.nvim',
      },
    })
  end,
}
