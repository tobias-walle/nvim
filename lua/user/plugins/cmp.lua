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

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    cmp.setup({
      mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
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
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
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
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
      },
      preselect = cmp.PreselectMode.None,
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
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
