---@type LazySpec
local plugin = {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  config = function()
    local U = require('user.utils.neo-tree')
    local events = require('neo-tree.events')

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
        hijack_netrw_behavior = 'open_current',
        follow_current_file = { enabled = true },
        group_empty_dirs = false,
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
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
          },
        },
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
        width = 80,
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
          event = events.FILE_OPENED,
          handler = function(file_path)
            --auto close
            require('neo-tree').close_all()
          end,
        },
        {
          event = events.NEO_TREE_BUFFER_ENTER,
          handler = function()
            vim.opt_local.number = true
            vim.opt_local.relativenumber = true
            vim.opt_local.signcolumn = 'no'
          end,
        },
        {
          event = events.FILE_MOVED,
          handler = U.on_file_moved,
        },
        {
          event = events.FILE_RENAMED,
          handler = U.on_file_moved,
        },
      },
    })
  end,
}

return plugin
