---@type LazySpec
local plugin = {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'b0o/schemastore.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    local L = require('user.utils.lsp')

    -- Config of visuals
    vim.lsp.inlay_hint.enable()
    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = true,
      virtual_lines = false,
    })

    -- Default config
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- Conflicting lsps
    L.setup_aucmd_preventing_lsp_conflicts({ { 'denols', 'ts_ls' } })

    -- Python
    vim.lsp.enable('pyright')
    -- Python Linting
    vim.lsp.enable('ruff')
    -- R
    vim.lsp.enable('r_language_server')
    -- Go
    vim.lsp.enable('gopls')
    -- Terraform
    vim.lsp.enable('terraformls')
    -- Nushell
    vim.lsp.enable('nushell')
    -- Kotlin
    vim.lsp.enable('kotlin_language_server')
    -- Java
    vim.lsp.config('jdtls', {
      settings = {
        java = {
          format = {
            enabled = false,
          },
        },
      },
    })
    vim.lsp.enable('jdtls')
    -- TOML
    vim.lsp.enable('taplo')
    -- Nix
    vim.lsp.enable('nil_ls')
    vim.lsp.config('nil_ls', {
      settings = {
        ['nil'] = {
          formatting = {
            command = { 'nixpkgs-fmt' },
          },
        },
      },
    })
    -- JSONNet
    -- vim.lsp.enable('jsonnet_ls')
    -- Haskell
    -- vim.lsp.config('hls', {
    --   capabilities = no_formatting_capabilities,
    -- })
    -- vim.lsp.enable('hls')
    -- Helm Charts
    vim.lsp.enable('helm_ls')
    -- YAML
    vim.lsp.config('yamlls', {
      settings = {
        keyOrdering = false,
        yaml = {
          schemas = require('schemastore').yaml.schemas(),
          schemaStore = {
            enable = false,
            url = '', -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          },
        },
      },
    })
    vim.lsp.enable('yamlls')
    -- Angular
    -- vim.lsp.enable('angularls')
    -- Deno
    vim.lsp.enable('denols')
    vim.lsp.config('denols', {
      root_dir = L.root_dir({ 'deno.json', 'deno.jsonc' }),
    })
    -- CSS
    vim.lsp.enable('cssls')
    -- HTML
    vim.lsp.enable('html')
    -- JSON
    vim.lsp.enable('jsonls')
    L.ignore_lsp_formatting('jsonls')
    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })
    -- Graphql
    vim.lsp.enable('graphql')
    vim.lsp.config('graphql', {
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
    })
    -- ESLint
    vim.lsp.enable('eslint')
    vim.lsp.config('eslint', {
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
        'svelte',
        'astro',
        'html',
      },
    })
    -- Svelte
    vim.lsp.enable('svelte')
    L.ignore_lsp_formatting('svelte')
    -- C#
    -- vim.lsp.enable('csharp_ls')
    -- Rust
    vim.lsp.enable('rust_analyzer')
    vim.lsp.config('rust_analyzer', {
      standalone = false,
      settings = {
        ['rust-analyzer'] = {
          rustfmt = {
            extraArgs = { '+nightly' },
          },
          checkOnSave = { command = 'clippy' },
          cargo = {
            allFeatures = true,
          },
          completion = {
            callable = {
              snippets = 'none',
            },
          },
        },
      },
    })
    -- Lua
    vim.lsp.enable('lua_ls')
    L.ignore_lsp_formatting('lua_ls')
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          hint = { enable = true },
          diagnostics = {
            globals = { 'MiniTest' },
          },
        },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    })
    -- Typescript
    vim.lsp.config('ts_ls', L.ts_configure())
    vim.lsp.enable('ts_ls')
    L.ignore_lsp_formatting('ts_ls')
    -- Vue.js
    vim.lsp.enable('vue_ls')
    L.ignore_lsp_formatting('vue_ls')
  end,
}

return plugin
