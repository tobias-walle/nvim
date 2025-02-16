---@type LazySpec
local plugin = {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local oil = require('oil')
    local show_detail = false
    local oil_git_status = require('user.plugins.oil.git-status')

    oil_git_status.setup()

    oil.setup({
      default_file_explorer = true,
      skip_confirm_for_simple_edits = false,
      delete_to_trash = true,
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['L'] = 'actions.select',
        ['<C-s>'] = {
          'actions.select',
          opts = { vertical = true },
          desc = 'Open the entry in a vertical split',
        },
        ['<C-t>'] = {
          'actions.select',
          opts = { tab = true },
          desc = 'Open the entry in new tab',
        },
        ['<C-c>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['P'] = 'actions.preview',
        ['-'] = 'actions.parent',
        ['H'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = {
          'actions.cd',
          opts = { scope = 'tab' },
          desc = ':tcd to the current oil directory',
        },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = function()
            show_detail = not show_detail
            if show_detail then
              require('oil').set_columns({
                'icon',
                'permissions',
                'size',
                'mtime',
              })
            else
              require('oil').set_columns({ 'icon' })
            end
          end,
        },
      },
      columns = { 'icon' },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 10000,
        -- Buggy at the moment
        autosave_changes = false,
      },
      view_options = {
        show_hidden = true,
        -- is_hidden_file = function(name, bufnr)
        --   local status = oil_git_status.get_status(bufnr, name)
        --   local is_git_ignored = status and status.status == '!!' or false
        --   local starts_with_dot = name:match('^%.') ~= nil
        --   return starts_with_dot or is_git_ignored
        -- end,
      },
    })
  end,
}

return plugin
