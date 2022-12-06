local L = require('user.lsp.utils')

local lspconfig = require('lspconfig')
local null_ls = require('null-ls')

---@type LspConfig
local config = {
  lsp = {
    ['yamlls'] = L.setup_default,
    ['tailwindcss'] = L.setup_default,
    ['pyright'] = L.setup_default,
    ['r_language_server'] = L.setup_default,
    ['gopls'] = L.setup_default,
    ['kotlin_language_server'] = L.setup_default,
    ['taplo'] = L.setup_default,
    ['hls'] = { L.setup_without_formatting, install = false },
    ['tsserver'] = require('user.lsp.typescript').setup_typescript,
    ['angularls'] = { require('user.lsp.typescript').setup_angular, install = false },
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
        server = {
          standalone = false,
          on_attach = L.on_attach,
          settings = { ['rust-analyzer'] = { checkOnSave = { command = 'clippy' } } },
        },
      })
    end,
    ['sumneko_lua'] = function(name)
      require('neodev').setup({})
      lspconfig[name].setup({
        on_attach = L.on_attach_disable_formatting,
        settings = { Lua = { hint = { enable = true } } },
      })
    end,
  },
  null_ls = {
    ['stylua'] = L.setup_null_ls_formatting,
    ['black'] = L.setup_null_ls_formatting,
    ['prettierd'] = L.setup_null_ls_formatting,
    ['eslint_d'] = function(name)
      return {
        null_ls.builtins.formatting[name],
        null_ls.builtins.code_actions[name],
        null_ls.builtins.diagnostics[name].with({
          condition = function(utils)
            return utils.root_has_file({ '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yml', '.eslintrc.json' })
          end,
        }),
      }
    end,
    ['cspell'] = function(name)
      return {
        null_ls.builtins.code_actions[name],
        null_ls.builtins.diagnostics[name],
      }
    end,
  },
}

L.apply_config(config)

-- Nushell
require('nu').setup({})

-- Cargo.toml completion
require('crates').setup({
  null_ls = {
    enabled = true,
    name = 'crates.nvim',
  },
})

-- Signature Help
-- require('lsp_signature').setup({
--   hint_enable = true,
--   floating_window = false,
--   hint_prefix = '',
-- })

-- Better diagnostics
require('lsp_lines').setup()
vim.diagnostic.config({ virtual_lines = false })
vim.diagnostic.config({ virtual_text = true })

-- Inlay hints
local lspInlayhints = require('lsp-inlayhints')
lspInlayhints.setup()

vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = 'LspAttach_inlayhints',
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require('lsp-inlayhints').on_attach(client, bufnr)
  end,
})
