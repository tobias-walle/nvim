local M = {}

local U = require('user.utils')
local L = require('user.lsp.utils')
local lspconfig = require('lspconfig')

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

function M.setup_typescript()
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
        L.on_attach(client, bufnr)
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
  lspconfig.angularls.setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false

      disable_typescript_lsp_renaming_if_angular_is_active()
      L.on_attach(client, bufnr)
    end,
  })
end

return M
