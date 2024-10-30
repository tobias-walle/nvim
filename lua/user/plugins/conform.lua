---@type LazySpec
local plugin = {
  'stevearc/conform.nvim',
  lazy = false,
  config = function()
    local is_deno_project = function(bufnr)
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      return vim.fs.root(filepath, { 'deno.json', 'deno.jsonc' }) ~= nil
    end

    local prettier_or_deno = function(bufnr)
      if is_deno_project(bufnr) then
        return { 'deno_fmt' }
      else
        return { 'prettier', lsp_format = 'last' }
      end
    end

    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = prettier_or_deno,
        typescript = prettier_or_deno,
        markdown = prettier_or_deno,
        css = prettier_or_deno,
        scss = prettier_or_deno,
        sass = prettier_or_deno,
        yaml = prettier_or_deno,
        json = prettier_or_deno,
        json5 = prettier_or_deno,
        jsonc = prettier_or_deno,
        jsonnet = { 'jsonnetfmt' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
    })
  end,
}

return plugin
