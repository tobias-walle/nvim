---@diagnostic disable: missing-fields
---@type LazySpec
local plugin = {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    search = {
      -- when `true`, flash will be activated during regular search by default.
      -- You can always toggle when searching with `require("flash").toggle()`
      enabled = true,
      highlight = { backdrop = true },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        -- `forward` will be automatically set to the search direction
        -- `mode` is always set to `search`
        -- `incremental` is set to `true` when `incsearch` is enabled
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<tab>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}

return plugin
