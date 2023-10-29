local M = {}

local U = require('user.utils')
local async = require('plenary.async')

function M.system_open(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  -- macOS: open file in default application in the background.
  vim.api.nvim_command('silent !open -g ' .. path)
  -- Linux: open file in default application
  vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
end

function M.run_command_in_folder(state)
  local node = state.tree:get_node()
  local file = vim.fn.fnamemodify(node:get_id(), ':t')
  local folder = node:get_parent_id()
  vim.ui.input({ prompt = 'Run: ' }, function(command)
    if command ~= '' and command ~= nil then
      command = string.gsub(command, '%%', '"' .. file .. '"')
      vim.api.nvim_command('!cd "' .. folder .. '" && ' .. command)
    end
  end)
end

function M.run_command_on_file(state)
  local node = state.tree:get_node()
  local file = node:get_id()
  vim.ui.input({ prompt = 'Run: ' }, function(command)
    if command ~= '' and command ~= nil then
      command = string.gsub(command, '%%', '"' .. file .. '"')
      vim.api.nvim_command('!' .. command)
    end
  end)
end

function M.clipboard(state)
  local node = state.tree:get_node()
  local file = vim.fn.fnamemodify(node:get_id(), ':.')
  print('Copy "' .. file .. '" to clipboard')
  vim.fn.setreg('*', file, 'c')
  vim.fn.setreg('+', file, 'c')
end

function M.clipboard_full(state)
  local node = state.tree:get_node()
  local file = node:get_id()
  print('Copy "' .. file .. '" to clipboard')
  vim.fn.setreg('*', file, 'c')
  vim.fn.setreg('+', file, 'c')
end

function M.rename_visual(state, selected_nodes)
  async.run(function()
    if selected_nodes == nil then
      return
    end
    local sources = U.map(selected_nodes, function(node)
      local path = node:get_id()
      return vim.fn.fnamemodify(path, ':.')
    end)

    local destinations = U.show_edit_popup_async('Rename', sources)

    local moves = U.map(
      sources,
      function(source, i) return source .. '::' .. destinations[i] end
    )
    U.run_cmd_async({ 'refactor', 'move', table.unpack(moves) })
  end)
end

function M.smart_rename_visual(state, selected_nodes)
  async.run(function()
    if selected_nodes == nil then
      return
    end
    local sources = U.map(selected_nodes, function(node)
      local path = node:get_id()
      return vim.fn.fnamemodify(path, ':.')
    end)

    local destinations = U.show_edit_popup_async('Rename', sources)

    local moves = U.map(
      sources,
      function(source, i) return U.quote(source .. '::' .. destinations[i]) end
    )
    U.show_terminal_popup(
      'Rename',
      { 'refactor move --replace-usages ' .. U.join(moves, ' ') }
    )
  end)
end

function M.smart_rename(state)
  async.run(function()
    local path = state.tree:get_node():get_id()
    local source = vim.fn.fnamemodify(path, ':.')
    local destination =
      U.input_async({ prompt = 'Smart Rename: ', default = source })

    local move = U.quote(source .. '::' .. destination)
    U.show_terminal_popup(
      'Rename',
      { 'refactor move --replace-usages ' .. move }
    )
  end)
end

---@class FileMovedArgs
---@field source string
---@field destination string
---@param args FileMovedArgs
function M.on_file_moved(args)
  local ts_clients = vim.lsp.get_active_clients({ name = 'tsserver' })
  for _, ts_client in ipairs(ts_clients) do
    ts_client.request('workspace/executeCommand', {
      command = '_typescript.applyRenameFile',
      arguments = {
        {
          sourceUri = vim.uri_from_fname(args.source),
          targetUri = vim.uri_from_fname(args.destination),
        },
      },
    })
  end
end

return M
