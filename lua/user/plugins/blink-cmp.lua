---@type LazySpec
local plugin = {
  'saghen/blink.cmp',
  version = '1.*',
  lazy = false,
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    keymap = {
      preset = 'default', -- https://cmp.saghen.dev/configuration/keymap.html#default
      ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-p>'] = { 'select_prev', 'snippet_backward', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'snippet_forward', 'fallback_to_mappings' },
    },

    appearance = { nerd_font_variant = 'mono' },

    completion = {
      documentation = { auto_show = true },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
    },

    snippets = { preset = 'luasnip' },
    sources = {
      default = {
        'snippets',
        'lazydev',
        'lsp',
        'path',
        'buffer',
        'filename',
        'ai_chat',
      },
      providers = {
        snippets = {
          -- Give snippets a little bit priority
          score_offset = 1,
        },
        filename = {
          module = 'user.cmp-sources.filename',
          -- Slight deprioritize filename completions
          score_offset = -1,
        },
        -- see https://cmp.saghen.dev/recipes.html#buffer-completion-from-all-open-buffers
        buffer = {
          -- Deprioritize buffer completions
          score_offset = -2,
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(
                function(bufnr) return vim.bo[bufnr].buftype == '' end,
                vim.api.nvim_list_bufs()
              )
            end,
          },
        },
        lsp = {
          fallbacks = {},
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        ai_chat = { module = 'ai.cmp.chat' },
      },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      max_typos = function() return 0 end,
      sorts = {
        'score',
        'sort_text',
      },
    },
  },
  opts_extend = { 'sources.default' },
}

return plugin
