local M = {}

local U = require('user.utils')

function M.format()
  require('mini.trailspace').trim()
  require('conform').format({ timeout_ms = 5000 })
  -- vim.lsp.buf.format({ timeout_ms = 5000 })
end

---@alias LspSetupFun fun(name: string)
---@alias NullSetupFun fun(name: string): unknown[]
---@alias LspMap table<string, LspSetupFun | { [1]: LspSetupFun, install: boolean }>
---@alias NullMap table<string, NullSetupFun | { [1]: NullSetupFun, install: boolean }>
---@alias LspConfig { lsp: LspMap }

M.snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
M.snippet_capabilities.textDocument.completion.completionItem.snippetSupport =
  true

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require('user.core.keymaps').attach_completion()
end

function M.disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = nil
  client.server_capabilities.documentRangeFormattingProvider = nil
  client.server_capabilities.documentOnTypeFormattingProvider = nil
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
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = M.on_attach,
  })
end

function M.setup_without_formatting(server_name)
  local lspconfig = require('lspconfig')
  lspconfig[server_name].setup({
    on_attach = M.on_attach_with({ M.disable_formatting }),
  })
end

---@param config LspConfig
function M.apply_config(config)
  for server_name, options in pairs(config.lsp) do
    if type(options) == 'function' then
      options = { options }
    end
    local setup = options[1]
    setup(server_name)
  end
end

function M.deno_root_pattern()
  local lspconfig = require('lspconfig')
  return lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
end

function M.rp_if_not(root_pattern, other_pattern)
  return function(fname)
    if root_pattern(fname) then
      return nil
    end
    return other_pattern(fname)
  end
end

return M
