local M = {}

local U = require('user.utils')
local casing = require('user.utils.casing')

--- @param old_prefix string
--- @param new_prefix string
function M.rename_top_level_declarations_by_prefix(old_prefix, new_prefix)
  while true do
    local positions = M.find_top_level_declarations()
    local has_changed = false
    for _, position in ipairs(positions) do
      local cases = { casing.camelCase, casing.pascalCase }
      for _, case in ipairs(cases) do
        local old = case(casing.splitLowerCase(old_prefix))
        local new = case(casing.splitLowerCase(new_prefix))
        if
          U.starts_with(position.name, old)
          and not U.starts_with(position.name, new)
        then
          vim.fn.cursor(position.start_pos)
          M.rename(string.gsub(position.name, '^' .. old, new))
          has_changed = true
        end
      end
    end
    if not has_changed then
      break
    end
  end
  vim.api.nvim_command('wa!')
end

--- @return { start_pos: [integer, integer], end_pos: [integer, integer] }[]
function M.find_top_level_declarations()
  local tokens = {
    '( export_statement declaration: (_ name: (_) @name) )',
    '( export_statement declaration: (_ (variable_declarator name: (_) @name)) )',
  }

  local filetype = 'typescript'
  local parser = vim.treesitter.get_parser(0, filetype)
  local test = parser:parse()
  local root = test[1]:root()
  local results = {}
  for _, token_query in ipairs(tokens) do
    local query = vim.treesitter.parse_query(filetype, token_query)
    for _, node in query:iter_captures(root, 0, 0, -1) do
      local name = vim.treesitter.get_node_text(node, 0)
      local range = U.map({ node:range() }, function(p) return p + 1 end)
      local start_pos = { range[1], range[2] }
      local end_pos = { range[3], range[4] }
      table.insert(
        results,
        { name = name, start_pos = start_pos, end_pos = end_pos }
      )
    end
  end
  return results
end

function M.rename_prefix()
  local word_under_cursor = vim.fn.expand('<cword>')
  vim.ui.input(
    { prompt = 'Prefix: ', default = word_under_cursor },
    function(prefix)
      vim.ui.input(
        { prompt = 'New Prefix: ', default = prefix },
        function(new_prefix)
          M.rename_top_level_declarations_by_prefix(prefix, new_prefix)
        end
      )
    end
  )
end

--- Custom rename that works synchronously.
--- @param new_name string The new name. May contains % that will be replaced with the original name.
function M.rename(new_name)
  if string.find(new_name, '%%') then
    new_name = string.gsub(new_name, '%%', vim.fn.expand('<cword>'))
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({
    bufnr = bufnr,
    method = vim.lsp.textDocument_rename,
  })

  if #clients == 0 then
    vim.notify(
      '[LSP] Rename, no matching language servers with rename capability.'
    )
  end

  local win = vim.api.nvim_get_current_win()
  for _, client in ipairs(clients) do
    local params =
      vim.lsp.util.make_position_params(win, client.offset_encoding)
    params.newName = new_name

    local result, err =
      client.request_sync('textDocument/rename', params, 5000, bufnr)

    if result and result.result then
      vim.lsp.util.apply_workspace_edit(result.result, client.offset_encoding)
    elseif err then
      vim.notify(
        string.format('[LSP][%s] %s', client.name, err),
        vim.log.levels.WARN
      )
    end
  end
end

return M
