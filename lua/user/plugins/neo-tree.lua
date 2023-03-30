---@type LazyPlugin
local plugin = {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = false,
  branch = 'v2.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = { 'Neotree' },
  config = function()
    local U = require('user.utils.neo-tree')

    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require('neo-tree').setup({
      close_if_last_window = false,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = false,
      sort_case_insensitive = true,
      use_popups_for_input = false,
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          always_show = {},
          never_show = {},
        },
        follow_current_file = false,
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
            ['R'] = 'smart_rename',
          },
        },
        commands = {
          system_open = U.system_open,
          run_command_in_folder = U.run_command_in_folder,
          run_command_on_file = U.run_command_on_file,
          rename_visual = U.rename_visual,
          smart_rename = U.smart_rename,
          smart_rename_visual = U.smart_rename_visual,
          clipboard = U.clipboard,
          clipboard_full = U.clipboard_full,
        },
      },
      buffers = {
        follow_current_file = true,
        group_empty_dirs = true,
        show_unloaded = true,
        window = { mappings = { ['bd'] = 'buffer_delete', ['<bs>'] = 'navigate_up', ['.'] = 'set_root' } },
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
            ['gg'] = 'git_commit_and_push',
          },
        },
      },
      window = {
        position = 'left',
        width = 40,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ['<space>'] = 'none',
          ['/'] = 'none',
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['h'] = 'close_node',
          ['H'] = 'close_all_nodes',
          ['l'] = 'open',
          ['a'] = { 'add', config = { show_path = 'none' } },
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
          ['>'] = 'next_source',
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function(file_path)
            --auto close
            require('neo-tree').close_all()
          end,
        },
        {
          event = 'neo_tree_buffer_enter',
          handler = function()
            vim.opt_local.number = true
            vim.opt_local.relativenumber = true
            vim.opt_local.signcolumn = 'no'
          end,
        },
      },
    })
  end,
}

return plugin
