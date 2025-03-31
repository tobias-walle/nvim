--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts or {}
  return self
end

function source:get_completions(ctx, callback)
  -- Get the current file name without extension.
  local file_name = vim.fn.expand('%:t:r')
  local filetype = vim.api.nvim_buf_get_option(ctx.bufnr, 'filetype')

  -- If the file name is nil, return an empty completion list.
  if file_name == nil then
    callback({
      items = {},
      is_incomplete_backward = false,
      is_incomplete_forward = false,
    })
    return function() end
  end

  -- Remove '.spec' from the file name if present.
  file_name = string.gsub(file_name, '%.spec', '')

  -- Split the file name into lower case components.
  local casing = require('user.utils.casing')
  local split = casing.splitLowerCase(file_name)

  -- Initialize an empty list for completion items.
  local items = {}
  -- Add PascalCase completion item.
  table.insert(items, {
    label = casing.pascalCase(split),
    kind = require('blink.cmp.types').CompletionItemKind.Text,
  })

  -- Add SnakeCase or CamelCase completion item based on filetype.
  if casing.languageUsesSnakeCase(filetype) then
    table.insert(items, {
      label = casing.snakeCase(split),
      kind = require('blink.cmp.types').CompletionItemKind.Text,
    })
  else
    table.insert(items, {
      label = casing.camelCase(split),
      kind = require('blink.cmp.types').CompletionItemKind.Text,
    })
  end
  callback({
    items = items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })
  return function() end
end

-- Called immediately after applying the item's textEdit/insertText
function source:execute(ctx, item, callback, default_implementation)
  -- By default, your source must handle the execution of the item itself,
  -- but you may use the default implementation at any time
  default_implementation()
  -- The callback _MUST_ be called once
  callback()
end

return source
