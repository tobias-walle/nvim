---@type LazySpec
local plugin = {
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    local compare = cmp.config.compare
    local luasnip = require('luasnip')

    cmp.register_source('filename', require('user.utils.cmp-sources.filename').new())

    cmp.setup({
      mapping = require('user.core.keymaps').cmp_mapping(cmp),
      preselect = cmp.PreselectMode.None,
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        documentation = {
          max_height = 15,
          max_width = 60,
        },
      },

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
        { name = 'luasnip', keyword_length = 2, max_item_count = 5 },
      }),

      formatting = {
        fields = { 'abbr', 'menu', 'kind' },

        ---@param entry cmp.Entry
        ---@param item cmp.ItemField
        format = function(entry, item)
          local short_name = {
            nvim_lsp = 'LSP',
            nvim_lua = 'nvim',
            luasnip = 'snip',
          }

          local menu_name = short_name[entry.source.name] or entry.source.name

          item.menu = string.format('[%s]', menu_name)
          return item
        end,
      },

      experimental = { ghost_text = true },
    })
  end,
}

return plugin
