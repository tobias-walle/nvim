require('treesitter-context').setup({
  enable = true,
})
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  sync_install = false,
  highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,

      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
      },
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>np'] = '@parameter.inner',
        ['<leader>nb'] = '@block.outer',
        ['<leader>nf'] = '@function.outer',
      },
      swap_previous = {
        ['<leader>Np'] = '@parameter.inner',
        ['<leader>Nf'] = '@function.outer',
      },
    },
  },
})
