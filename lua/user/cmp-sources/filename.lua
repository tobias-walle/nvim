local S = {}
local cmp = require 'cmp'
local casing = require('user.utils.casing')

function S:new() return setmetatable({}, {__index = S}) end

function S:get_keyword_pattern() return [[\k\+]] end

function S:complete(params, callback)
  local name = vim.fn.expand('%:t:r')
  if (name == nil) then return end
  local split = casing.splitLowerCase(name)
  callback({
    {kind = cmp.lsp.CompletionItemKind.File, label = casing.camelCase(split)},
    {kind = cmp.lsp.CompletionItemKind.File, label = casing.pascalCase(split)}
  })
end

return S
