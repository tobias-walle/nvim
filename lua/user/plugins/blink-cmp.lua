---@type LazySpec
local plugin = {
  'saghen/blink.cmp',
  version = '1.*',
  lazy = false,
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'super-tab' },

    appearance = { nerd_font_variant = 'mono' },

    completion = { documentation = { auto_show = false } },

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
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}

return plugin
