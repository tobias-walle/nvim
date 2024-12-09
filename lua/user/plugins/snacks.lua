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
      debug = { enabled = true },
      notifier = {
        enabled = true,
        top_down = true,
        style = 'minimal',
        timeout = 3000,
      },
    })

    override_print()
  end,
}

return plugin
