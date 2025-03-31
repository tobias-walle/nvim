local M = {}

local U = require('user.utils')

--- @param names string | string[]
--- @return string[]
function M.splitLowerCase(names)
  if type(names) == 'string' then
    names = { names }
  end
  local result = {}
  for _, name in ipairs(names) do
    for str in string.gmatch(name, '(%u?[^%u%._-]+)') do
      table.insert(result, string.lower(str))
    end
  end
  return result
end

--- @param names string[]
--- @return string
function M.pascalCase(names)
  local result = ''
  for _, word in ipairs(names) do
    result = result .. string.sub(word, 1, 1):upper() .. string.sub(word, 2)
  end
  return result
end

--- @param names string[]
--- @return string
function M.camelCase(names)
  local result = ''
  for i, word in ipairs(names) do
    if i > 1 then
      result = result .. string.sub(word, 1, 1):upper() .. string.sub(word, 2)
    else
      result = result .. word
    end
  end
  return result
end

--- @param filetype string
--- @return boolean
function M.languageUsesSnakeCase(filetype)
  return filetype == 'rust'
    or filetype == 'python'
    or filetype == 'ruby'
    or filetype == 'lua'
end

--- @param names string[]
--- @return string
function M.snakeCase(names) return U.join(names, '_') end

return M
