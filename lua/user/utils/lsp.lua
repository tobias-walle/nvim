local M = {}

function M.root_dir(markers)
  return function(bufnr, set_root_dir)
    local root_dir = vim.fs.root(bufnr, markers)
    if root_dir then
      set_root_dir(root_dir)
    end
  end
end

function M.ts_configure()
  local ts_settings = {
    inlayHints = {
      includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayVariableTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
  }
  return {
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
    },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vim.fn.trim(vim.fn.system('pnpm root -g'))
            .. '/@vue/typescript-plugin',
          languages = { 'javascript', 'typescript', 'vue' },
        },
      },
    },
    settings = {
      typescript = ts_settings,
      javascript = ts_settings,
    },
  }
end

---@param combinations string[][]
function M.setup_aucmd_preventing_lsp_conflicts(combinations)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('ConditionalLspStop', { clear = true }),
    callback = function()
      local clients = vim.lsp.get_clients()
      for _, lsps in ipairs(combinations) do
        local stop_others = false
        for _, lsp in ipairs(lsps) do
          local client = vim
            .iter(clients)
            :find(function(client) return client.name == lsp end)
          if client then
            if stop_others then
              client:stop(true)
            else
              stop_others = true
            end
          end
        end
      end
    end,
  })
end

-- List of lsps that should not be used for formatting
---@type string[]
M.__lsp_ignore_formatting = {}

---@param lsp_name string
function M.ignore_lsp_formatting(lsp_name)
  table.insert(M.__lsp_ignore_formatting, lsp_name)
end

function M.format()
  require('mini.trailspace').trim()
  require('conform').format({
    timeout_ms = 5000,
    filter = function(client)
      local any_client_ignored = vim.iter(M.__lsp_ignore_formatting):any(
        function(client_name) return client.name == client_name end
      )
      return not any_client_ignored
    end,
  })
end

function M.ts_remove_unused_imports()
  vim.lsp.buf.code_action({
    context = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      only = { 'source.removeUnusedImports.ts' },
      diagnostics = {},
    },
    apply = true,
  })
end

function M.ts_add_missing_imports()
  vim.lsp.buf.code_action({
    context = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      only = { 'source.addMissingImports.ts' },
      diagnostics = {},
    },
    apply = true,
  })
end

function M.ts_fix_imports()
  local bufnr = vim.api.nvim_get_current_buf()

  -- 1. Get all error diagnostics in the buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  local error_diags = {}
  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      table.insert(error_diags, diag)
    end
  end

  if #error_diags == 0 then
    vim.notify(
      'No import errors found, skipping deletion.',
      vim.log.levels.INFO
    )
  else
    -- 2. Use Treesitter query to find all import statements
    local parser = vim.treesitter.get_parser(bufnr, 'typescript')
    if not parser then
      vim.notify(
        'Treesitter parser not found for filetype: ' .. vim.bo.filetype,
        vim.log.levels.WARN
      )
      return
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Query to capture import statements (works for TS/JS)
    local query = vim.treesitter.query.parse(
      'typescript',
      [[
      (import_statement) @import
      ]]
    )

    local import_ranges = {}

    for _, node, _ in query:iter_captures(root, bufnr, 0, -1) do
      local start_row, start_col, end_row, end_col = node:range()

      -- Check if this import overlaps any error diagnostic
      local overlaps_error = false
      for _, diag in ipairs(error_diags) do
        local range = diag.user_data.lsp.range
        local dsr = range.start.line
        local dsc = range.start.character
        local der = range['end'].line
        local dec = range['end'].character

        -- Overlap check (simple range overlap)
        if not (end_row < dsr or start_row > der) then
          overlaps_error = true
          break
        end
      end

      if overlaps_error then
        table.insert(import_ranges, { start_row, end_row })
      end
    end

    -- Delete import lines from bottom to top to keep line numbers valid
    table.sort(import_ranges, function(a, b) return a[1] > b[1] end)
    for _, range in ipairs(import_ranges) do
      -- Delete lines from start_row to end_row (inclusive)
      vim.api.nvim_buf_set_lines(bufnr, range[1], range[2] + 1, false, {})
    end
  end

  -- 3. Refresh LSP and run code action to add missing imports
  vim.defer_fn(M.ts_add_missing_imports, 1000)
end

return M
