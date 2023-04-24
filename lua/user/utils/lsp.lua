local M = {}

local U = require('user.utils')

function M.format()
  vim.cmd('silent! EslintFixAll')
  vim.lsp.buf.format()
end

---@alias LspSetupFun fun(name: string)
---@alias NullSetupFun fun(name: string): unknown[]
---@alias LspMap table<string, LspSetupFun | { [1]: LspSetupFun, install: boolean }>
---@alias NullMap table<string, NullSetupFun | { [1]: NullSetupFun, install: boolean }>
---@alias LspConfig { lsp: LspMap, null_ls: NullMap }

M.snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
M.snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require('user.core.keymaps').attach_completion(bufnr)
end

function M.disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
end

function M.on_attach_disable_formatting(client, bufnr)
  M.disable_formatting(client)
  M.on_attach(client, bufnr)
end

function M.setup_default(server_name)
  local lspconfig = require('lspconfig')
  lspconfig[server_name].setup({
    on_attach = M.on_attach,
  })
end

function M.setup_without_formatting(server_name)
  local lspconfig = require('lspconfig')
  lspconfig[server_name].setup({
    on_attach = M.on_attach_disable_formatting,
  })
end

function M.setup_null_ls_formatting(name)
  local null_ls = require('null-ls')
  return {
    null_ls.builtins.formatting[name],
  }
end

function M.setup_null_ls_diagnostics(name)
  local null_ls = require('null-ls')
  return {
    null_ls.builtins.diagnostics[name],
  }
end

---@param config LspConfig
function M.apply_config(config)
  local null_ls = require('null-ls')

  local ensure_installed = {
    lsp = {},
    null_ls = {},
  }

  for server_name, options in pairs(config.lsp) do
    if type(options) == 'function' then
      options = { options }
    end
    local setup = options[1]
    local install = options.install ~= false
    if install then
      table.insert(ensure_installed.lsp, server_name)
    end
    setup(server_name)
  end

  local null_ls_sources = {}
  for name, options in pairs(config.null_ls) do
    if type(options) == 'function' then
      options = { options }
    end
    local get_sources = options[1]
    local install = options.install ~= false
    if install then
      table.insert(ensure_installed.null_ls, name)
    end
    local new_sources = get_sources(name)
    vim.list_extend(null_ls_sources, new_sources)
  end
  null_ls.setup({
    sources = null_ls_sources,
    on_attach = M.on_attach,
  })

  require('mason').setup()
  require('mason-lspconfig').setup({ ensure_installed = ensure_installed.lsp })
  require('mason-tool-installer').setup({ ensure_installed = ensure_installed.null_ls })
end

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
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end

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

function M.setup_typescript()
  local lspconfig = require('lspconfig')
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
        M.disable_formatting(client)

        disable_typescript_lsp_renaming_if_angular_is_active()
        M.on_attach(client, bufnr)
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

  -- Allow comments in tsconfig
  vim.cmd([[

  autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
  ]])
end

function M.setup_angular()
  local lspconfig = require('lspconfig')
  lspconfig.angularls.setup({
    on_attach = function(client, bufnr)
      M.disable_formatting(client)

      disable_typescript_lsp_renaming_if_angular_is_active()
      M.on_attach(client, bufnr)
    end,
  })
end

function M.on_attach_csharp(client, bufnr)
  M.on_attach(client, bufnr)
  -- Workaround to prevent error
  -- Source: https://nicolaiarocci.com/making-csharp-and-omnisharp-play-well-with-neovim/
  client.server_capabilities.semanticTokensProvider = {
    full = vim.empty_dict(),
    legend = {
      tokenModifiers = { 'static_symbol' },
      tokenTypes = {
        'comment',
        'excluded_code',
        'identifier',
        'keyword',
        'keyword_control',
        'number',
        'operator',
        'operator_overloaded',
        'preprocessor_keyword',
        'string',
        'whitespace',
        'text',
        'static_symbol',
        'preprocessor_text',
        'punctuation',
        'string_verbatim',
        'string_escape_character',
        'class_name',
        'delegate_name',
        'enum_name',
        'interface_name',
        'module_name',
        'struct_name',
        'type_parameter_name',
        'field_name',
        'enum_member_name',
        'constant_name',
        'local_name',
        'parameter_name',
        'method_name',
        'extension_method_name',
        'property_name',
        'event_name',
        'namespace_name',
        'label_name',
        'xml_doc_comment_attribute_name',
        'xml_doc_comment_attribute_quotes',
        'xml_doc_comment_attribute_value',
        'xml_doc_comment_cdata_section',
        'xml_doc_comment_comment',
        'xml_doc_comment_delimiter',
        'xml_doc_comment_entity_reference',
        'xml_doc_comment_name',
        'xml_doc_comment_processing_instruction',
        'xml_doc_comment_text',
        'xml_literal_attribute_name',
        'xml_literal_attribute_quotes',
        'xml_literal_attribute_value',
        'xml_literal_cdata_section',
        'xml_literal_comment',
        'xml_literal_delimiter',
        'xml_literal_embedded_expression',
        'xml_literal_entity_reference',
        'xml_literal_name',
        'xml_literal_processing_instruction',
        'xml_literal_text',
        'regex_comment',
        'regex_character_class',
        'regex_anchor',
        'regex_quantifier',
        'regex_grouping',
        'regex_alternation',
        'regex_text',
        'regex_self_escaped_character',
        'regex_other_escape',
      },
    },
    range = true,
  }
end

return M
