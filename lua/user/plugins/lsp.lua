---@type LazySpec
local plugin = {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
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
    local null_ls = require('null-ls')

    ---@type LspConfig
    local config = {
      lsp = {
        ['tailwindcss'] = L.setup_default,
        ['pyright'] = L.setup_default,
        ['r_language_server'] = { L.setup_default, install = false },
        ['gopls'] = L.setup_default,
        ['kotlin_language_server'] = L.setup_without_formatting,
        ['taplo'] = L.setup_default,
        ['hls'] = { L.setup_without_formatting, install = false },
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
        ['jsonls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_disable_formatting,
            capabilities = L.snippet_capabilities,
            settings = { json = { schemas = require('schemastore').json.schemas() } },
          })
        end,
        ['omnisharp'] = function(name)
          local pid = vim.fn.getpid()
          local omnisharp_bin = 'omnisharp'
          lspconfig[name].setup({
            cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
            on_attach = L.on_attach,
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
        ['eslint_d'] = function(name)
          return {
            null_ls.builtins.formatting[name],
            null_ls.builtins.code_actions[name],
            null_ls.builtins.diagnostics[name].with({
              condition = function(utils)
                return utils.root_has_file({
                  '.eslintrc.js',
                  '.eslintrc.cjs',
                  '.eslintrc.yml',
                  '.eslintrc.json',
                  '.eslintrc',
                })
              end,
            }),
          }
        end,
      },
    }

    L.apply_config(config)
  end,
}

return plugin
