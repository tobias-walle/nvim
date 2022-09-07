-- Hop
require'hop'.setup {}

-- Spectre (Search & Replace)
require'spectre'.setup {}

-- Autopairs
require'nvim-autopairs'.setup {enable_moveright = false}

-- Autotags
require'nvim-ts-autotag'.setup {}

-- Which key
require('which-key').setup {}

-- Gitsigns
require('gitsigns').setup {keymaps = {}}

-- Git Merge Tool
vim.g.mergetool_layout = 'mr'
vim.g.mergetool_prefer_revision = 'local'

-- Project Nvim
require('project_nvim').setup {manual_mode = true}
require('telescope').load_extension('projects')

-- Neoclip
require('neoclip').setup {}

-- Cargo Toml
vim.cmd [[ autocmd BufRead Cargo.toml call crates#toggle() ]]

-- Neoterm
vim.g.neoterm_default_mod = 'belowright'

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  sync_install = false,
  highlight = {enable = true, disable = {}, additional_vim_regex_highlighting = false},
  indent = {enable = false},
  context_commentstring = {enable = true, enable_autocmd = false},
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
      show_help = '?'
    }
  }
}

-- Luasnip
require('luasnip.loaders.from_snipmate').load()

-- Comments
require('Comment').setup {
  pre_hook = function(ctx)
    local U = require 'Comment.utils'

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require('ts_context_commentstring.utils').get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require('ts_context_commentstring.utils').get_visual_start_location()
    end

    return require('ts_context_commentstring.internal').calculate_commentstring {
      key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
      location = location
    }
  end
}
