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
    local lsp_picker_config_override = {
      jump = { tagstack = true, reuse_win = false },
    }
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
      -- https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
      quickfile = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
      rename = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
      scratch = {},
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
        replace_netrw = false,
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      picker = {
        sources = {
          lsp_declarations = lsp_picker_config_override,
          lsp_definitions = lsp_picker_config_override,
          lsp_implementations = lsp_picker_config_override,
          lsp_references = lsp_picker_config_override,
          lsp_type_definitions = lsp_picker_config_override,
          explorer = {
            auto_close = true,
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
      win = {
        input = {
          keys = {
            ['s'] = { 'flash' },
            ['ss'] = { 'flash' },
          },
        },
      },
      actions = {
        flash = function(picker)
          require('flash').jump({
            pattern = '^',
            label = { after = { 0, 0 } },
            search = {
              mode = 'search',
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                    ~= 'snacks_picker_list'
                end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          })
        end,
      },
    })
    override_print()
  end,
}

return plugin
