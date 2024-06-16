local M = {}

local U = require('user.utils')

function M.format()
  require('mini.trailspace').trim()
  vim.cmd('silent! EslintFixAll')
  vim.lsp.buf.format({ timeout_ms = 5000 })
end

---@alias LspSetupFun fun(name: string)
---@alias NullSetupFun fun(name: string): unknown[]
---@alias LspMap table<string, LspSetupFun | { [1]: LspSetupFun, install: boolean }>
---@alias NullMap table<string, NullSetupFun | { [1]: NullSetupFun, install: boolean }>
---@alias LspConfig { lsp: LspMap, null_ls: NullMap }

M.snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
M.snippet_capabilities.textDocument.completion.completionItem.snippetSupport =
  true

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require('user.core.keymaps').attach_completion()
end

function M.disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
end

function M.disable_semantic_tokens(client)
  client.server_capabilities.semanticTokensProvider = nil
end

function M.on_attach_with(on_attach_extras)
  return function(client, bufnr)
    for _, on_attach_extra in ipairs(on_attach_extras) do
      on_attach_extra(client)
    end
    M.on_attach(client, bufnr)
  end
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
    on_attach = M.on_attach_with({ M.disable_formatting }),
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

  for server_name, options in pairs(config.lsp) do
    if type(options) == 'function' then
      options = { options }
    end
    local setup = options[1]
    setup(server_name)
  end

  local null_ls_sources = {}
  for name, options in pairs(config.null_ls) do
    if type(options) == 'function' then
      options = { options }
    end
    local get_sources = options[1]
    local new_sources = get_sources(name)
    vim.list_extend(null_ls_sources, new_sources)
  end
  null_ls.setup({
    sources = null_ls_sources,
    on_attach = M.on_attach,
  })
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
  local ts_active = U.some(
    clients,
    function(client) return client.name == 'tsserver' end
  )
  local ng_active = U.some(
    clients,
    function(client) return client.name == 'angularls' end
  )
  if ts_active and ng_active then
    local ts_client = U.find(
      clients,
      function(client) return client.name == 'tsserver' end
    )
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
            return vim.lsp.handlers['textDocument/definition'](
              err,
              filtered_result,
              method,
              ...
            )
          end

          vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
        end,
      },

      root_dir = lspconfig.util.root_pattern('.git'),

      settings = {
        typescript = { inlayHints = ts_inlay_hint_options },
        javascript = { inlayHints = ts_inlay_hint_options },
      },
    },
  })

  -- Allow comments in json files
  vim.cmd([[
  autocmd BufNewFile,BufRead *.json setlocal filetype=jsonc
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

return M
