local function override_print()
  _G.dd = function(...) Snacks.debug.inspect(...) end
  _G.bt = function() Snacks.debug.backtrace() end
  vim.print = _G.dd
  print = _G.dd
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
