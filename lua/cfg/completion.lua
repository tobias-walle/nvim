vim.cmd [[
set completeopt=menuone,noinsert,noselect
set shortmess+=c
]]

-- See https://github.com/simrat39/rust-tools.nvim#configuration
local lspconfig = require 'lspconfig'
local bindings = require 'cfg.bindings'

require'lsp_signature'.setup()

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  bindings.attach_completion(bufnr)
end

lspconfig.kotlin_language_server.setup {on_attach = on_attach}
lspconfig.yamlls.setup {on_attach = on_attach}
lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {Lua = {diagnostics = {globals = {'vim'}}}}
}
lspconfig.jsonls.setup {on_attach = on_attach}

local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  on_attach = on_attach,
  mapping = bindings.cmp_mapping(cmp),

  -- Installed sources
  sources = {
    {name = 'nvim_lsp'}, {name = 'path'}, {name = 'luasnip'}, {name = 'buffer'}, {name = 'crates'}
  }
})

-- Null Ls
require('null-ls').setup {
  sources = {
    require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.formatting.eslint_d,
    require('null-ls').builtins.formatting.lua_format
  }
}

-- Rust
require('rust-tools').setup({
  tools = { -- rust-tools options
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = '',
      other_hints_prefix = ''
    }
  },

  server = {
    on_attach = on_attach,
    settings = {['rust-analyzer'] = {checkOnSave = {command = 'clippy'}}}
  }
})


-- Typescript
lspconfig.tsserver.setup({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = require('nvim-lsp-ts-utils').init_options,
  --
  on_attach = function(client, bufnr)
    local ts_utils = require('nvim-lsp-ts-utils')

    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = true,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4 -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = 'Comment',

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    client.resolved_capabilities.document_formatting = false

    on_attach(client, bufnr)
  end
})
