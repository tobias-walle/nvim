vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require('neo-tree').setup({
  close_if_last_window = false,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = false,
  sort_case_insensitive = false,
  window = {
    position = 'left',
    width = 40,
    mapping_options = {noremap = true, nowait = true},
    mappings = {
      ['<space>'] = 'toggle_node',
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
  },
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
        ['.'] = 'set_root'
        --[[ ['/'] = 'fuzzy_finder', ]]
        --[[ ['D'] = 'fuzzy_finder_directory', ]]
        --[[ ['f'] = 'filter_on_submit', ]]
        --[[ ['<c-x>'] = 'clear_filter', ]]
        --[[ ['[g'] = 'prev_git_modified', ]]
        --[[ [']g'] = 'next_git_modified' ]]
      }
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
  }
})
