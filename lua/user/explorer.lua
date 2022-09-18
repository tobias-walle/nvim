local U = require('user.utils')
local async = require('plenary.async')

local function system_open(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  -- macOs: open file in default application in the background.
  -- Probably you need to adapt the Linux recipe for manage path with spaces. I don't have a mac to try.
  vim.api.nvim_command('silent !open -g ' .. path)
  -- Linux: open file in default application
  vim.api.nvim_command(string.format('silent !xdg-open \'%s\'', path))
end

local function run_command_in_folder(state)
  local node = state.tree:get_node()
  local file = vim.fn.fnamemodify(node:get_id(), ':t')
  local folder = node:get_parent_id()
  vim.ui.input({prompt = 'Run: '}, function(command)
    if (command ~= '' and command ~= nil) then
      command = string.gsub(command, '%%', '"' .. file .. '"')
      vim.api.nvim_command('!cd "' .. folder .. '" && ' .. command)
    end
  end)
end

local function run_command_on_file(state)
  local node = state.tree:get_node()
  local file = node:get_id()
  vim.ui.input({prompt = 'Run: '}, function(command)
    if (command ~= '' and command ~= nil) then
      command = string.gsub(command, '%%', '"' .. file .. '"')
      vim.api.nvim_command('!' .. command)
    end
  end)
end

local function clipboard(state)
  local node = state.tree:get_node()
  local file = vim.fn.fnamemodify(node:get_id(), ':.')
  print('Copy "' .. file .. '" to clipboard')
  vim.fn.setreg('*', file, 'c')
  vim.fn.setreg('+', file, 'c')
end

local function clipboard_full(state)
  local node = state.tree:get_node()
  local file = node:get_id()
  print('Copy "' .. file .. '" to clipboard')
  vim.fn.setreg('*', file, 'c')
  vim.fn.setreg('+', file, 'c')
end

local function rename_visual(state, selected_nodes)
  async.run(function()
    if selected_nodes == nil then return end
    local sources = U.map(selected_nodes, function(node)
      local path = node:get_id()
      return vim.fn.fnamemodify(path, ':.')
    end)

    local destinations = U.show_edit_popup_async('Rename', sources)

    local moves = U.map(sources, function(source, i) return source .. '::' .. destinations[i] end)
    U.run_cmd_async({'refactor', 'move', table.unpack(moves)})
  end)
end

local function smart_rename_visual(state, selected_nodes)
  async.run(function()
    if selected_nodes == nil then return end
    local sources = U.map(selected_nodes, function(node)
      local path = node:get_id()
      return vim.fn.fnamemodify(path, ':.')
    end)

    local destinations = U.show_edit_popup_async('Rename', sources)

    local moves = U.map(sources,
                        function(source, i) return U.quote(source .. '::' .. destinations[i]) end)
    U.show_terminal_popup('Rename', {'refactor move --replace-usages ' .. U.join(moves, ' ')})
  end)
end

local function smart_rename(state)
  async.run(function()
    local path = state.tree:get_node():get_id();
    local source = vim.fn.fnamemodify(path, ':.')
    local destination = U.input_async({prompt = 'Smart Rename: ', default = source});

    local move = U.quote(source .. '::' .. destination)
    U.show_terminal_popup('Rename', {'refactor move --replace-usages ' .. move})
  end)
end

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require('neo-tree').setup({
  close_if_last_window = false,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = false,
  sort_case_insensitive = true,
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      always_show = {},
      never_show = {}
    },
    follow_current_file = true,
    group_empty_dirs = false,
    hijack_netrw_behavior = 'open_current',
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ['<bs>'] = 'navigate_up',
        ['.'] = 'set_root',
        ['o'] = 'system_open',
        ['i'] = 'run_command_in_folder',
        ['I'] = 'run_command_on_file',
        ['y'] = 'clipboard',
        ['Y'] = 'clipboard_full',
        ['R'] = 'smart_rename'
      }
    },
    commands = {
      system_open = system_open,
      run_command_in_folder = run_command_in_folder,
      run_command_on_file = run_command_on_file,
      rename_visual = rename_visual,
      smart_rename = smart_rename,
      smart_rename_visual = smart_rename_visual,
      clipboard = clipboard,
      clipboard_full = clipboard_full
    }
  },
  buffers = {
    follow_current_file = true,
    group_empty_dirs = true,
    show_unloaded = true,
    window = {mappings = {['bd'] = 'buffer_delete', ['<bs>'] = 'navigate_up', ['.'] = 'set_root'}}
  },
  git_status = {
    window = {
      position = 'float',
      mappings = {
        ['A'] = 'git_add_all',
        ['gu'] = 'git_unstage_file',
        ['ga'] = 'git_add_file',
        ['gr'] = 'git_revert_file',
        ['gc'] = 'git_commit',
        ['gp'] = 'git_push',
        ['gg'] = 'git_commit_and_push'
      }
    }
  },
  window = {
    position = 'left',
    width = 40,
    mapping_options = {noremap = true, nowait = true},
    mappings = {
      ['<space>'] = 'none',
      ['<2-LeftMouse>'] = 'open',
      ['<cr>'] = 'open',
      ['S'] = 'open_split',
      ['s'] = 'open_vsplit',
      ['t'] = 'open_tabnew',
      ['w'] = 'open_with_window_picker',
      ['h'] = 'close_node',
      ['H'] = 'close_all_nodes',
      ['l'] = 'open',
      ['a'] = {'add', config = {show_path = 'none'}},
      ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add".
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['c'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source'
    }
  }
})
