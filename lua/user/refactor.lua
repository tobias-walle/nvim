local M = {}

local async = require('plenary.async')

local async_input = async.wrap(function(...)
  vim.ui.input(...)
end, 2)

---@param symbol string
---@param replacement string
local search_and_replace = function(symbol, replacement)
  local filetype = vim.bo.filetype
  local parser = vim.treesitter.get_parser(0, filetype)
  local test = parser:parse()
  local root = test[1]:root()
  local query = vim.treesitter.parse_query(
    filetype,
    [[
    (variable_declaration  (identifier) @name)
  ]]
  )

  for _, match, metadata in query:iter_matches(root, 0) do
    dbg(vim.treesitter.get_node_text(match[1], 0))
    local pos = metadata.content[1]
    local start_pos = { pos[1] + 1, pos[2] + 1 }
    vim.fn.cursor(start_pos)
    vim.lsp.buf.rename('test')
    println('Rename')
    break
  end

  -- local original_pos = vim.api.nvim_win_get_cursor(0)
  -- local pattern = '\\<' .. symbol .. '\\>'
  -- vim.fn.cursor({1, 1})
  -- local first_match = vim.fn.searchpos(pattern)
  -- if vim.deep_equal(first_match, {0, 0}) then return end
  -- local match = first_match
  -- while (true) do
  --   dbg(match)
  --
  --   vim.fn.cursor(match)
  --   match = vim.fn.searchpos(pattern)
  --   if vim.deep_equal(match, first_match) then break end
  -- end
  -- vim.fn.cursor(original_pos)
end

M.smart_rename = function()
  search_and_replace('async_input', '')
  async.run(function()
    -- local input = async_input({
    --   prompt = 'Rename File and Symbol: ',
    --   default = vim.fn.expand('%:t:r')
    -- })
    -- vim.lsp.buf.rename('test')
    -- print(input)
    -- require('typescript').renameFile(vim.fn.expand('%'), input)
    -- vim.api.nvim_win_set_cursor(0, {13, 33})
  end)
end

M.a = function()
  M.smart_rename()
end
local search = 'smart_renxxame'

return M
