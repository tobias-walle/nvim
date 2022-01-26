local S = {}
local cmp = require 'cmp'

function S:new()
  return setmetatable({}, {__index = S})
end

function S:get_keyword_pattern()
  return [[\k\+]]
end

function S:complete(params, callback)
  callback({{kind = cmp.lsp.CompletionItemKind.File, label = vim.fn.expand('%:t:r')}})
end

return S
