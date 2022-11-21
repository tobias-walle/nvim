local U = require('user.utils')

local lspconfig = require('lspconfig')
local bindings = require('user.bindings')

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'gopls',
    'sumneko_lua',
    'omnisharp',
    'pyright',
    'r_language_server',
    'tailwindcss',
    'hls',
    'yamlls',
    'kotlin_language_server',
    'cssls',
    'jsonls',
  },
})

local snipet_capabilities = vim.lsp.protocol.make_client_capabilities()
snipet_capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  bindings.attach_completion(bufnr)
end

local on_attach_disable_formatting = function(client, bufnr)
  client.server_capabilities.document_formatting = false
  on_attach(client, bufnr)
end

lspconfig.kotlin_language_server.setup({ on_attach = on_attach })
lspconfig.yamlls.setup({ on_attach = on_attach })
lspconfig.hls.setup({ on_attach = on_attach_disable_formatting })
lspconfig.pyright.setup({ on_attach = on_attach })
lspconfig.gopls.setup({ on_attach = on_attach })
lspconfig.r_language_server.setup({ on_attach = on_attach })
lspconfig.taplo.setup({ cmd = { 'taplo', 'lsp', 'stdio' }, on_attach = on_attach })
-- lspconfig.tailwindcss.setup {on_attach = on_attach}

-- Nushell
require('nu').setup({})

-- Lua
require('neodev').setup({})
lspconfig.sumneko_lua.setup({
  on_attach = on_attach_disable_formatting,
})

lspconfig.cssls.setup({ on_attach = on_attach_disable_formatting, capabilities = snipet_capabilities })

lspconfig.jsonls.setup({
  capabilities = snipet_capabilities,
  settings = { json = { schemas = require('schemastore').json.schemas() } },
  on_attach = on_attach_disable_formatting,
})

local pid = vim.fn.getpid()
local omnisharp_bin = '/usr/local/bin/omnisharp'
lspconfig.omnisharp.setup({
  cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
  on_attach = on_attach,
})

local cmp = require('cmp')
local compare = cmp.config.compare
cmp.register_source('filename', require('user.cmp-sources.filename').new())
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  on_attach = on_attach,
  mapping = bindings.cmp_mapping(cmp),

  sorting = {
    comparators = {
      compare.score,
      compare.offset,
      compare.exact,
      compare.scopes,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp', max_item_count = 10 },
    { name = 'path' },
    { name = 'crates' },
    { name = 'buffer', keyword_length = 3, max_item_count = 5 },
    { name = 'filename' },
    { name = 'luasnip', max_item_count = 5 },
  }),
  experimental = { ghost_text = true },
})

-- Allow comments in tsconfig
vim.cmd([[
set completeopt=menuone,noinsert,noselect
set shortmess+=c

autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
]])

-- Signature Help
require('lsp_signature').setup({ hint_enable = true, floating_window = false, hint_prefix = '' })

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
  on_attach = on_attach,
})

-- Rust
require('rust-tools').setup({
  tools = { autoSetHints = false, hover_with_actions = false },

  server = {
    standalone = false,
    on_attach = on_attach,
    settings = { ['rust-analyzer'] = { checkOnSave = { command = 'clippy' } } },
  },
})

-- Typescript
local function ts_filter(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function ts_filter_react_dts(value)
  return string.match(value.uri, 'react/index.d.ts') == nil
end

-- lspconfig.denols.setup {
--   on_attach = on_attach,
--   root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
-- }

local function disable_typescript_lsp_renaming_if_angular_is_active()
  local clients = vim.lsp.get_active_clients()
  local ts_active = U.some(clients, function(client)
    return client.name == 'tsserver'
  end)
  local ng_active = U.some(clients, function(client)
    return client.name == 'angularls'
  end)
  if ts_active and ng_active then
    local ts_client = U.find(clients, function(client)
      return client.name == 'tsserver'
    end)
    if ts_client ~= nil then
      ts_client.server_capabilities.renameProvider = false
    end
  end
end

local ts_inlay_hint_options = {
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

require('typescript').setup({
  server = {

    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false

      disable_typescript_lsp_renaming_if_angular_is_active()
      on_attach(client, bufnr)
    end,

    handlers = {
      ['textDocument/definition'] = function(err, result, method, ...)
        if vim.tbl_islist(result) and #result > 1 then
          local filtered_result = ts_filter(result, ts_filter_react_dts)
          return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
        end

        vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
      end,
    },

    root_dir = lspconfig.util.root_pattern('package.json'),

    settings = {
      typescript = { inlayHints = ts_inlay_hint_options },
      javascript = { inlayHints = ts_inlay_hint_options },
    },
  },
})

lspconfig.angularls.setup({
  on_attach = function(client, bufnr)
    disable_typescript_lsp_renaming_if_angular_is_active()
    on_attach(client, bufnr)
  end,
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
