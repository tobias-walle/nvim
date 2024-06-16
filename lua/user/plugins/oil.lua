---@type LazySpec
local plugin = {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local show_detail = false
    require('oil').setup({
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
        timeout_ms = 10000,
        autosave_changes = true,
      },
      view_options = {
        show_hidden = false,
      },
    })
  end,
}

return plugin
