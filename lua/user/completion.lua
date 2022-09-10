vim.cmd [[
set completeopt=menuone,noinsert,noselect
set shortmess+=c

autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
]]

-- See https://github.com/simrat39/rust-tools.nvim#configuration
local lspconfig = require 'lspconfig'
local bindings = require 'user.bindings'
local lspInlayhints = require 'lsp-inlayhints';

require('mason').setup()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  bindings.attach_completion(bufnr)
  lspInlayhints.on_attach(client, bufnr, false)
end

lspInlayhints.setup {}

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach_disable_formatting = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  on_attach(client, bufnr)
end

local pid = vim.fn.getpid()
local omnisharp_bin = '/usr/local/bin/omnisharp'
require'lspconfig'.omnisharp.setup {
  cmd = {omnisharp_bin, '--languageserver', '--hostPID', tostring(pid)},
  on_attach = on_attach
}

lspconfig.kotlin_language_server.setup {on_attach = on_attach}
lspconfig.yamlls.setup {on_attach = on_attach}
lspconfig.hls.setup {on_attach = on_attach_disable_formatting}
--[[ lspconfig.tailwindcss.setup {on_attach = on_attach} ]]

local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()
cssls_capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup {on_attach = on_attach_disable_formatting, capabilities = cssls_capabilities}

local luadev = require('lua-dev').setup {
  lspconfig = {
    on_attach = on_attach_disable_formatting
    -- settings = {Lua = {diagnostics = {globals = {'vim'}}}}
  }
}
lspconfig.sumneko_lua.setup(luadev)

lspconfig.jsonls.setup {
  capabilities = cssls_capabilities,
  settings = {json = {schemas = require('schemastore').json.schemas()}},
  on_attach = on_attach_disable_formatting
}
lspconfig.pyright.setup {on_attach = on_attach}
lspconfig.taplo.setup {cmd = {'taplo', 'lsp', 'stdio'}, on_attach = on_attach}
lspconfig.angularls.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.rename = false
    on_attach(client, bufnr)
  end
}

local cmp = require 'cmp'
cmp.register_source('filename', require('user.cmp-sources.filename').new())
cmp.setup({
  snippet = {expand = function(args) require('luasnip').lsp_expand(args.body) end},
  on_attach = on_attach,
  mapping = bindings.cmp_mapping(cmp),

  sources = {
    {name = 'nvim_lsp'}, {name = 'path'}, {name = 'luasnip'}, {name = 'buffer'}, {name = 'crates'},
    {name = 'filename'}
  }
})

-- Signature Help
require'lsp_signature'.setup {hint_enable = true, floating_window = false, hint_prefix = ''}

-- Null Ls
require('null-ls').setup {
  sources = {
    require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.diagnostics.eslint_d.with {
      condition = function(utils)
        return utils.root_has_file({'.eslintrc.js', '.eslintrc.yml', '.eslintrc.json'})
      end
    }, require('null-ls').builtins.formatting.eslint_d,
    require('null-ls').builtins.code_actions.eslint_d,
    require('null-ls').builtins.formatting.lua_format, require('null-ls').builtins.formatting.black
  },
  on_attach = on_attach
}

-- Rust
require('rust-tools').setup({
  tools = {autoSetHints = false, hover_with_actions = false},

  server = {
    standalone = false,
    on_attach = on_attach,
    settings = {['rust-analyzer'] = {checkOnSave = {command = 'clippy'}}}
  }
})

-- Typescript
local function ts_filter(arr, fn)
  if type(arr) ~= 'table' then return arr end

  local filtered = {}
  for k, v in pairs(arr) do if fn(v, k, arr) then table.insert(filtered, v) end end

  return filtered
end

local function ts_filter_react_dts(value) return string.match(value.uri, 'react/index.d.ts') == nil end

-- lspconfig.denols.setup {
--   on_attach = on_attach,
--   root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
-- }

local ts_inlay_hint_options = {
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true
}

require('typescript').setup({
  server = {

    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false

      on_attach(client, bufnr)
    end,

    handlers = {
      ['textDocument/definition'] = function(err, result, method, ...)
        print('HERE')
        if vim.tbl_islist(result) and #result > 1 then
          local filtered_result = ts_filter(result, ts_filter_react_dts)
          return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
        end

        vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
      end
    },

    root_dir = lspconfig.util.root_pattern('package.json'),

    settings = {
      typescript = {inlayHints = ts_inlay_hint_options},
      javascript = {inlayHints = ts_inlay_hint_options}
    }
  }
})

-- Better diagnostics
require('lsp_lines').setup()
vim.diagnostic.config({virtual_lines = false})
vim.diagnostic.config({virtual_text = false})
