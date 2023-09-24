local M = {}

local U = require('user.utils')

function M.format()
  vim.cmd('silent! EslintFixAll')
  vim.lsp.buf.format({ timeout_ms = 5000 })
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

function M.disable_formatting(client) client.server_capabilities.documentFormattingProvider = false end

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

local function ts_filter_react_dts(value) return string.match(value.targetUri, 'react/index.d.ts') == nil end

local function disable_typescript_lsp_renaming_if_angular_is_active()
  local clients = vim.lsp.get_active_clients()
  local ts_active = U.some(clients, function(client) return client.name == 'typescript-tools' end)
  local ng_active = U.some(clients, function(client) return client.name == 'angularls' end)
  if ts_active and ng_active then
    local ts_client = U.find(clients, function(client) return client.name == 'typescript-tools' end)
    if ts_client ~= nil then
      ts_client.server_capabilities.renameProvider = false
    end
  end
end

function M.setup_typescript()
  require('typescript-tools').setup({
    on_attach = function(client, bufnr)
      M.disable_formatting(client)

      disable_typescript_lsp_renaming_if_angular_is_active()
      M.on_attach(client, bufnr)
    end,
    settings = {
      tsserver_plugins = {
        '@styled/typescript-styled-plugin',
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  })

  -- Allow comments in tsconfig
  vim.cmd('autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc')
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
