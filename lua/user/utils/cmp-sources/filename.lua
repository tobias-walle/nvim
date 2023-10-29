local S = {}

function S:new() return setmetatable({}, { __index = S }) end

function S:get_keyword_pattern() return [[\k\+]] end

function S:complete(params, callback)
  local name = vim.fn.expand('%:t:r')
  if name == nil then
    callback({})
    return
  end
  name = string.gsub(name, '%.spec', '')
  local casing = require('user.utils.casing')
  local split = casing.splitLowerCase(name)
  local items = {}

  local function add_items()
    local casing = require('user.utils.casing')
    table.insert(items, { label = casing.pascalCase(split) })
    if casing.languageUsesSnakeCase(params.context.filetype) then
      table.insert(items, { label = casing.snakeCase(split) })
    else
      table.insert(items, { label = casing.camelCase(split) })
    end
  end

  add_items()
  table.remove(split, #split)
  add_items()

  callback(items)
end

return S
