---@type LazySpec
local plugin = {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/typescript.nvim',
    'simrat39/rust-tools.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'folke/neodev.nvim',
  },
  config = function()
    local L = require('user.utils.lsp')

    local lspconfig = require('lspconfig')

    ---@type LspConfig
    local config = {
      lsp = {
        ['pyright'] = L.setup_default,
        ['r_language_server'] = { L.setup_default, install = false },
        ['gopls'] = L.setup_default,
        ['kotlin_language_server'] = L.setup_without_formatting,
        ['taplo'] = L.setup_default,
        ['bufls'] = L.setup_default,
        ['jsonnet_ls'] = L.setup_default,
        ['hls'] = { L.setup_without_formatting, install = false },
        ['tailwindcss'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach,
            filetypes = {
              'css',
              'scss',
              'sass',
              'postcss',
              'html',
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
              'svelte',
              'vue',
              'rust',
            },
            init_options = {
              userLanguages = {
                rust = 'html',
              },
            },
          })
        end,
        ['yamlls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            settings = {
              keyOrdering = false,
              yaml = {
                schemas = require('schemastore').json.schemas(),
              },
            },
          })
        end,
        ['tsserver'] = L.setup_typescript,
        ['angularls'] = { L.setup_angular, install = false },
        ['cssls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            capabilities = L.snippet_capabilities,
          })
        end,
        ['html'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            capabilities = L.snippet_capabilities,
          })
        end,
        ['jsonls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            capabilities = L.snippet_capabilities,
            settings = {
              json = { schemas = require('schemastore').json.schemas() },
            },
          })
        end,
        ['eslint'] = L.setup_default,
        ['svelte'] = L.setup_default,
        ['csharp_ls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach,
            root_dir = function(startpath)
              return lspconfig.util.root_pattern('*.sln')(startpath)
                or lspconfig.util.root_pattern('*.csproj')(startpath)
                or lspconfig.util.root_pattern('*.fsproj')(startpath)
                or lspconfig.util.root_pattern('.git')(startpath)
            end,
          })
        end,
        ['rust_analyzer'] = function()
          require('rust-tools').setup({
            tools = { autoSetHints = false, hover_with_actions = false },
            reload_workspace_from_cargo_toml = false,
            server = {
              standalone = false,
              on_attach = L.on_attach,
              settings = {
                ['rust-analyzer'] = {
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
            },
          })
        end,
        ['lua_ls'] = function(name)
          require('neodev').setup({})
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            settings = {
              Lua = {
                hint = { enable = true },
              },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          })
        end,
      },
      null_ls = {
        ['stylua'] = L.setup_null_ls_formatting,
        ['black'] = L.setup_null_ls_formatting,
        ['prettier'] = L.setup_null_ls_formatting,
        ['jsonnetfmt'] = { L.setup_null_ls_formatting, install = false },
      },
    }

    L.apply_config(config)
  end,
}

return plugin
