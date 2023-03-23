-- Hop
require('leap').add_default_mappings()

-- Which key
require('which-key').setup({})

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Neoclip
require('neoclip').setup({})

-- Neoterm
vim.g.neoterm_default_mod = 'belowright'

-- Undotree
vim.g.undotree_WindowLayout = 2

-- Aerial (Outline)
require('aerial').setup()

-- Autoclose brackets
require('nvim-autopairs').setup({
  enable_moveright = true,
  fast_wrap = {},
})

-- Comments
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Autoclose tags
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

-- Colors
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

-- Paste Images
require('clipboard-image').setup({
  default = {
    img_dir = { '%:p:h', 'media' },
    img_dir_txt = 'media',
    img_name = function()
      return vim.fn.input('Image Filename: ')
    end,
  },
})
