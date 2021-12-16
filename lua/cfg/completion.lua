vim.cmd [[
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c
]]

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local lspconfig = require 'lspconfig'

require'lsp_signature'.setup()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function boption(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  local function bnmap(alias, definition)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', alias, definition, {noremap = true, silent = true})
  end

  -- Enable completion triggered by <c-x><c-o>
  boption('omnifunc', 'v:lua.vim.lsp.omnifunc')

  bnmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bnmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bnmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bnmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  bnmap('<space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bnmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bnmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  bnmap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  bnmap('<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  bnmap('<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
  bnmap('<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  bnmap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  bnmap('<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  bnmap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
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
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})
  },

  -- Installed sources
  sources = {
    {name = 'nvim_lsp'}, {name = 'path'}, {name = 'luasnip'}, {name = 'buffer'}, {name = 'crates'}
  }
})

require('null-ls').setup {
  sources = {
    -- require('null-ls').builtins.formatting.rustfmt,
    -- require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.formatting.eslint_d,
    require('null-ls').builtins.formatting.lua_format
  }
}

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
      enable_import_on_completion = false,

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
      auto_inlay_hints = false,
      inlay_hints_highlight = 'Comment',

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    on_attach(client, bufnr)
    -- no default maps, so you may want to define some here
    -- local opts = { silent = true }
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
  end
})

