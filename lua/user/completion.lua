local cmp = require('cmp')
local compare = cmp.config.compare

cmp.register_source('filename', require('user.cmp-sources.filename').new())

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = require('user.bindings').cmp_mapping(cmp),

  sorting = {
    comparators = {
      compare.score,
      compare.offset,
      compare.exact,
      compare.scopes,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp', keyword_length = 0 },
    { name = 'path' },
    { name = 'crates' },
    { name = 'buffer', keyword_length = 3, max_item_count = 5 },
    { name = 'filename' },
    { name = 'luasnip', max_item_count = 5 },
    { name = 'crates' },
  }),
  experimental = { ghost_text = true },
})
