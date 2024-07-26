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
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require('cmp')
    local compare = cmp.config.compare
    local luasnip = require('luasnip')

    cmp.register_source(
      'filename',
      require('user.utils.cmp-sources.filename').new()
    )

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-n>'] = cmp.mapping(function(fallback)
          local luasnip = require('luasnip')
          if cmp.visible() then
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          else
            cmp.complete()
          end
        end, { 'i', 's' }),
        -- Switch to codium results if completion winodw is open
        ['<C-a>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = 'codeium' },
                }),
              },
            })
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-p>'] = cmp.mapping(function(fallback)
          local luasnip = require('luasnip')
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
      },
      preselect = cmp.PreselectMode.None,
      ---@diagnostic disable-next-line: missing-fields
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      ---@diagnostic disable-next-line: missing-fields
      window = {
        ---@diagnostic disable-next-line: missing-fields
        documentation = {
          max_height = 15,
          max_width = 60,
        },
      },

      ---@diagnostic disable-next-line: missing-fields
      sorting = {
        comparators = {
          compare.score,
          compare.offset,
          compare.exact,
          compare.recently_used,
          compare.locality,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      },

      sources = cmp.config.sources({
        { name = 'luasnip', max_item_count = 5 },
        { name = 'nvim_lsp', keyword_length = 0, max_item_count = 30 },
        { name = 'path' },
        { name = 'buffer', keyword_length = 1, max_item_count = 5 },
        { name = 'filename' },
        { name = 'codeium' },
      }),

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        fields = { 'abbr', 'menu', 'kind' },

        format = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          symbol_map = { Codeium = '' },
        }),
      },

      experimental = { ghost_text = false },
    })
  end,
}

return plugin
