-- Hop
require('hop').setup({})

-- Autopairs
require('nvim-autopairs').setup({ enable_moveright = false })

-- Autotags
require('nvim-ts-autotag').setup({})

-- Which key
require('which-key').setup({})

-- Gitsigns
require('gitsigns').setup({ keymaps = {} })

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Neoclip
require('neoclip').setup({})

-- Cargo Toml
vim.cmd([[ autocmd BufRead Cargo.toml call crates#toggle() ]])

-- Neoterm
vim.g.neoterm_default_mod = 'belowright'

-- Undotree
vim.g.mundo_width = 45
vim.g.mundo_preview_height = 30
vim.g.mundo_preview_height = 30
vim.g.mundo_preview_bottom = true

-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  sync_install = false,
  highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = false },
  indent = { enable = false },
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
        ['<leader>Nb'] = '@block.outer',
        ['<leader>Nf'] = '@function.outer',
      },
    },
  },
})

-- Comments
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Yode
--[[ require('yode-nvim.helper').getIndentCount = function(text) return 0 end ]]
--[[ require('yode-nvim').setup({}) ]]
