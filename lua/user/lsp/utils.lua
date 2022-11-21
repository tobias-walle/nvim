local M = {}

local snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require('user.bindings').attach_completion(bufnr)
end

function M.on_attach_disable_formatting(client, bufnr)
  client.server_capabilities.document_formatting = false
  M.on_attach(client, bufnr)
end

return M
