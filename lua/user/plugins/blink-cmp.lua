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
        'lsp',
        'path',
        'snippets',
        'buffer',
        'filename',
        'ai_chat',
      },
      providers = {
        ai_chat = { module = 'ai.cmp.chat' },
        filename = { module = 'user.cmp-sources.filename' },
        -- see https://cmp.saghen.dev/recipes.html#buffer-completion-from-all-open-buffers
        buffer = {
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
      },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      max_typos = function() return 1 end,
      sorts = {
        'exact', -- Always prioritize exact matches
        'score',
        'sort_text',
      },
    },
  },
  opts_extend = { 'sources.default' },
}

return plugin
