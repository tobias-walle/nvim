local npairs = require('nvim-autopairs')

npairs.setup({ enable_moveright = false })

require('nvim-ts-autotag').setup({
  -- For WASM UI frameworks like Leptos in Rust
  filetypes = { 'rust' },
})
