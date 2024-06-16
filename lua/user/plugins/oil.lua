---@type LazySpec
local plugin = {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
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
      },
      columns = {
        'icon',
        'mtime',
      },
      lsp_file_methods = {
        timeout_ms = 10000,
        autosave_changes = true,
      },
      view_options = {
        show_hidden = true,
      },
    })
  end,
}

return plugin
