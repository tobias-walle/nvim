local S = {}
local cmp = require('cmp')
local casing = require('user.utils.casing')

function S:new()
  return setmetatable({}, { __index = S })
end

function S:get_keyword_pattern()
  return [[\k\+]]
end

function S:complete(params, callback)
  local name = vim.fn.expand('%:t:r')
  if name == nil then
    callback({})
    return
  end
  local split = casing.splitLowerCase(name)
  local pc = { label = casing.pascalCase(split) }
  local cc = { label = casing.camelCase(split) }
  local sc = { label = casing.snakeCase(split) }
  if params.context.filetype == 'rust' then
    callback({ pc, sc })
  elseif params.context.filetype == 'python' then
    callback({ pc, sc })
  else
    callback({ pc, cc })
  end
end

return S
