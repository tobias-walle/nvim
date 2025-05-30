local function override_print()
  dbg = Snacks.debug.inspect
  bt = Snacks.debug.backtrace
  vim.print = dbg
end

---@type LazySpec
local plugin = {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  config = function()
    require('snacks').setup({
      -- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
      debug = { enabled = true },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
      notifier = {
        enabled = true,
        top_down = true,
        style = 'minimal',
        timeout = 3000,
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
      words = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
      indent = {
        animate = {
          enabled = false,
        },
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
      quickfile = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
      dashboard = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/input.md
      input = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/image.md
      image = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
      lazygit = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
      statuscolumn = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
      explorer = {
        replace_netrw = true,
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ['-'] = 'explorer_close',
                  ['<C-p>'] = false,
                },
              },
            },
          },
        },
      },
    })
    override_print()
  end,
}

return plugin
