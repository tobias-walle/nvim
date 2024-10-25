---@type LazySpec
local plugin = {
  'stevearc/conform.nvim',
  event = 'BufEnter',
  config = function()
    local javascript = { 'prettier', lsp_format = 'last' }
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = javascript,
        typescript = javascript,
        markdown = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        sass = { 'prettier' },
        yaml = { 'prettier' },
        json = { 'prettier' },
        json5 = { 'prettier' },
        jsonc = { 'prettier' },
        jsonnet = { 'jsonnetfmt' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
    })
  end,
}

return plugin
