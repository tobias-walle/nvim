local npairs = require('nvim-autopairs')
npairs.setup({
  enable_moveright = true,
  fast_wrap = {},
})

require('nvim-ts-autotag').setup({
  filetypes = {
    -- For WASM UI frameworks like Leptos in Rust
    'rust',
    -- Default values
    'html',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'svelte',
    'vue',
    'tsx',
    'jsx',
    'rescript',
    'xml',
    'php',
    'markdown',
    'glimmer',
    'handlebars',
    'hbs',
    'htmldjango',
  },
})
