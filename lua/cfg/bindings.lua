local M = {}

local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
end

local function map_for_buffer(bufnr)
  return function(mode, shortcut, command)
    vim.api.nvim_buf_set_keymap(bufnr, mode, shortcut, command, {noremap = true, silent = true})
  end
end

-- Tabs
map('n', 'th', ':tabprev<CR>')
map('n', 'tl', ':tabnext<CR>')
map('n', 'te', ':tabnew<CR>')
map('n', 'tc', ':tabclose<CR>')

-- Copy/Pasta
map('v', '<Leader>y', '"+y')

-- Pane Switching
map('n', '<C-j>', '<C-W>j')
map('n', '<C-k>', '<C-W>k')
map('n', '<C-h>', '<C-W>h')
map('n', '<C-l>', '<C-W>l')

-- HopL
map('n', 's', ':HopWord<CR>')

-- Undo Tree
map('n', '<F5>', ':UndotreeToggle<CR>')

-- File Tree
map('n', '<C-n>', ':NvimTreeToggle<CR>')
map('n', '<leader>r', ':NvimTreeRefresh<CR>')
map('n', '<leader>n', ':NvimTreeFindFileToggle<CR>')

-- Telescope
map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<C-f>', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<C-c>', '<cmd>lua require("telescope.builtin").commands()<cr>')
map('n', '<C-b>', '<cmd>lua require("telescope").buffers()<cr>')
-- map('n', '', '<cmd>lua require("telescope.builtin").extensions.neoclip.default()<cr>')

-- Completion
M.attach_completion = function(bufnr)
  local bmap = map_for_buffer(bufnr)
  bmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  bmap('n', '<space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  bmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  bmap('n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  bmap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
  bmap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  bmap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  bmap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  bmap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

M.cmp_mapping = function(cmp)
  return {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})
  }
end

-- Typescript
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

return M
