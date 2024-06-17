---@type LazySpec
local plugin = {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/typescript.nvim',
    'simrat39/rust-tools.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'folke/neodev.nvim',
  },
  config = function()
    local L = require('user.utils.lsp')

    local lspconfig = require('lspconfig')

    --- NOTE: I am using nix to manager the installed language servers
    ---@type LspConfig
    local config = {
      lsp = {
        ['pyright'] = L.setup_default,
        ['ruff_lsp'] = L.setup_default,
        ['graphql'] = L.setup_default,
        ['r_language_server'] = L.setup_default,
        ['gopls'] = L.setup_default,
        ['kotlin_language_server'] = L.setup_without_formatting,
        ['taplo'] = L.setup_default,
        ['bufls'] = L.setup_default,
        ['nil_ls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_semantic_tokens }),
            settings = {
              ['nil'] = {
                formatting = {
                  command = { 'nixpkgs-fmt' },
                },
              },
            },
          })
        end,
        ['jsonnet_ls'] = L.setup_default,
        ['hls'] = L.setup_without_formatting,
        ['helm_ls'] = L.setup_default,
        ['yamlls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_formatting }),
            settings = {
              keyOrdering = false,
              yaml = {
                schemas = require('schemastore').json.schemas(),
              },
            },
          })
        end,
        ['tsserver'] = L.setup_typescript,
        ['angularls'] = L.setup_angular,
        ['cssls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_formatting }),
            capabilities = L.snippet_capabilities,
          })
        end,
        ['html'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_formatting }),
            capabilities = L.snippet_capabilities,
          })
        end,
        ['jsonls'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_formatting }),
            capabilities = L.snippet_capabilities,
            settings = {
              json = { schemas = require('schemastore').json.schemas() },
            },
          })
        end,
        ['eslint'] = function(name)
          lspconfig[name].setup({
            on_attach = L.on_attach,
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
        end,
        ['svelte'] = function(name)
          L.setup_default(name)
          lspconfig[name].setup({
            on_attach = function(client, bufnr)
              L.on_attach(client, bufnr)
              --- Workaround for https://github.com/sveltejs/language-tools/issues/2008
              vim.api.nvim_create_autocmd('BufWritePost', {
                pattern = { '*.js', '*.ts' },
                callback = function(ctx)
                  client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
                end,
                group = vim.api.nvim_create_augroup(
                  'svelte_file_watcher',
                  { clear = true }
                ),
              })
            end,
          })
        end,
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
            },
          })
        end,
        ['lua_ls'] = function(name)
          require('neodev').setup({})
          lspconfig[name].setup({
            on_attach = L.on_attach_with({ L.disable_formatting }),
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
        ['prettier'] = L.setup_null_ls_formatting,
        ['jsonnetfmt'] = L.setup_null_ls_formatting,
      },
    }

    L.apply_config(config)
  end,
}

return plugin
