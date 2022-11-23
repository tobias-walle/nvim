local M = {}

local lspconfig = require('lspconfig')
local null_ls = require('null-ls')

---@alias LspSetupFun fun(name: string)
---@alias NullSetupFun fun(name: string): unknown[]
---@alias LspMap table<string, LspSetupFun | { [1]: LspSetupFun, install: boolean }>
---@alias NullMap table<string, NullSetupFun>
---@alias LspConfig { lsp: LspMap, null_ls: NullMap }

M.snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
M.snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require('user.bindings').attach_completion(bufnr)
end

function M.on_attach_disable_formatting(client, bufnr)
  client.server_capabilities.document_formatting = false
  M.on_attach(client, bufnr)
end

function M.setup_default(server_name)
  lspconfig[server_name].setup({
    on_attach = M.on_attach,
  })
end

function M.setup_without_formatting(server_name)
  lspconfig[server_name].setup({
    on_attach = M.on_attach_disable_formatting,
  })
end

function M.setup_null_ls_formatting(name)
  return {
    null_ls.builtins.formatting[name],
  }
end

---@param config LspConfig
function M.apply_config(config)
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
  for name, get_sources in pairs(config.null_ls) do
    table.insert(ensure_installed.null_ls, name)
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

return M
