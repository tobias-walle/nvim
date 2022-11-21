local U = require('user.utils')
local L = require('user.lsp.utils')

local lspconfig = require('lspconfig')

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'angularls',
    'cssls',
    'gopls',
    'hls', -- Haskell
    'jsonls',
    'kotlin_language_server',
    'omnisharp',
    'pyright',
    'r_language_server',
    'rust_analyzer',
    'sumneko_lua',
    'tailwindcss',
    'taplo',
    'tsserver',
    'yamlls',
  },
})
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = L.on_attach,
    })
  end,
  ['angularls'] = require('user.lsp.typescript').setup_angular,
  ['cssls'] = function(server_name)
    lspconfig[server_name].setup({
      on_attach = L.on_attach_disable_formatting,
      capabilities = L.snippet_capabilities,
    })
  end,
  ['hls'] = function(server_name)
    lspconfig[server_name].setup({
      on_attach = L.on_attach_disable_formatting,
    })
  end,
  ['jsonls'] = function(server_name)
    lspconfig[server_name].setup({
      on_attach = L.on_attach_disable_formatting,
      capabilities = L.snippet_capabilities,
      settings = { json = { schemas = require('schemastore').json.schemas() } },
    })
  end,
  ['omnisharp'] = function(server_name)
    local pid = vim.fn.getpid()
    local omnisharp_bin = '/usr/local/bin/omnisharp'
    lspconfig[server_name].setup({
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
  ['sumneko_lua'] = function(server_name)
    require('neodev').setup({})
    lspconfig[server_name].setup({
      on_attach = L.on_attach_disable_formatting,
    })
  end,
  ['taplo'] = function(server_name)
    lspconfig[server_name].setup({
      on_attach = L.on_attach,
    })
  end,
  ['tsserver'] = require('user.lsp.typescript').setup_typescript,
})

-- Nushell
require('nu').setup({})

-- Signature Help
require('lsp_signature').setup({
  hint_enable = true,
  floating_window = false,
  hint_prefix = '',
})

-- Null Ls
require('null-ls').setup({
  sources = {
    require('null-ls').builtins.formatting.prettier,

    require('null-ls').builtins.diagnostics.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({ '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yml', '.eslintrc.json' })
      end,
    }),
    require('null-ls').builtins.formatting.eslint_d,
    require('null-ls').builtins.code_actions.eslint_d,

    require('null-ls').builtins.formatting.stylua,
    require('null-ls').builtins.formatting.black,
  },
  on_attach = L.on_attach,
})

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
