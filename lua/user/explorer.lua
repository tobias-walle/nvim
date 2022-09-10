local U = require('user.utils')

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

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

local function rename_visual(state, selected_nodes)
  if selected_nodes == nil then return end
  local sources = U.map(selected_nodes, function(node)
    local path = node:get_id()
    return {relative = vim.fn.fnamemodify(path, ':.'), root = vim.fn.fnamemodify(path, ':h')}
  end)

  local source_paths = U.map(sources, function(f) return f.relative end)
  U.show_edit_popup('Rename', source_paths, function(destination_paths)
    local results = U.map(sources, function(source, i)
      return {source = source, destination = destination_paths[i]}
    end)
    table.sort(results,
               function(a, b) return string.len(a.source.root) > string.len(b.source.root) end)

    for _, result in ipairs(results) do
      local source = result.source.relative;
      local destination = result.destination;
      if (destination ~= '' and source ~= destination) then
        print('Move ' .. source .. ' to ' .. destination)
        U.file_move(source, destination)
      end
    end
  end)

  --[[ local old_name = vim.fn.fnamemodify(old_path, ':t') ]]

end

require('neo-tree').setup({
  close_if_last_window = false,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = false,
  sort_case_insensitive = false,
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
        ['I'] = 'run_command_on_file'
      }
    },
    commands = {
      system_open = system_open,
      run_command_in_folder = run_command_in_folder,
      run_command_on_file = run_command_on_file,
      rename_visual = rename_visual
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
      ['y'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['c'] = 'copy',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source'
    }
  }
})
