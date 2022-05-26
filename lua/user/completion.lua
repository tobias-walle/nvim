vim.cmd [[
set completeopt=menuone,noinsert,noselect
set shortmess+=c
]]

-- See https://github.com/simrat39/rust-tools.nvim#configuration
local lspconfig = require 'lspconfig'
local bindings = require 'user.bindings'

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  bindings.attach_completion(bufnr)
end

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach_disable_formatting = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
end

lspconfig.kotlin_language_server.setup {on_attach = on_attach}
lspconfig.yamlls.setup {on_attach = on_attach}
lspconfig.hls.setup {on_attach = on_attach_disable_formatting}
lspconfig.sumneko_lua.setup {
  on_attach = on_attach_disable_formatting,
  settings = {Lua = {diagnostics = {globals = {'vim'}}}}
}
lspconfig.jsonls.setup {
  capabilities = capabilities,
  settings = {json = {schemas = require('schemastore').json.schemas()}},
  on_attach = on_attach_disable_formatting
}
lspconfig.pyright.setup {on_attach = on_attach}
lspconfig.taplo.setup {cmd = {'taplo', 'lsp', 'stdio'}, on_attach = on_attach}

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
require'lsp_signature'.setup {hint_enable = false}

-- Null Ls
require('null-ls').setup {
  sources = {
    require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.formatting.eslint_d,
    require('null-ls').builtins.diagnostics.eslint_d,
    require('null-ls').builtins.code_actions.eslint_d,
    require('null-ls').builtins.formatting.lua_format,
    require('null-ls').builtins.formatting.black
  },
  on_attach = on_attach
}

-- Rust
require('rust-tools').setup({
  tools = { -- rust-tools options
    autoSetHints = true,
    hover_with_actions = false,
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = '',
      other_hints_prefix = ''
    }
  },

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

lspconfig.tsserver.setup({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = require('nvim-lsp-ts-utils').init_options,
  --
  on_attach = function(client, bufnr)
    local ts_utils = require('nvim-lsp-ts-utils')

    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = true,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4 -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = 'Comment',

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    client.resolved_capabilities.document_formatting = false

    on_attach(client, bufnr)
  end,
  handlers = {
    ['textDocument/definition'] = function(err, result, method, ...)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = ts_filter(result, ts_filter_react_dts)
        return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
    end
  }
})
