---@type LazySpec
local plugin = {
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'LspAttach',
    config = function()
      require('lsp_lines').setup()
      vim.diagnostic.config({ virtual_lines = false })
      vim.diagnostic.config({ severity_sort = true, virtual_text = true })
    end,
  },
  {
    'lvimuser/lsp-inlayhints.nvim',
    event = 'LspAttach',
    config = function()
      local lspInlayhints = require('lsp-inlayhints')
      lspInlayhints.setup()

      vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
      vim.api.nvim_create_autocmd('LspAttach', {
        group = 'LspAttach_inlayhints',
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require('lsp-inlayhints').on_attach(client, bufnr)
        end,
      })
    end,
  },
}

return plugin
