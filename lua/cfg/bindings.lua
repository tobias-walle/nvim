local M = {}

-- Utils
local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
end

local function map_for_buffer(bufnr)
  return function(mode, shortcut, command)
    vim.api.nvim_buf_set_keymap(bufnr, mode, shortcut, command, {noremap = true, silent = true})
  end
end

-- Leader
map('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Tabs
map('n', 'th', ':tabprev<CR>')
map('n', 'tl', ':tabnext<CR>')
map('n', 'tn', ':tabnew<CR>')
map('n', 'ts', ':tab split<CR>')
map('n', 'tc', ':tabclose<CR>')

-- Copy/Pasta
map('v', '<Leader>y', '"+y')

-- Pane Switching
map('n', 'J', '<C-W>j')
map('n', 'K', '<C-W>k')
map('n', 'H', '<C-W>h')
map('n', 'L', '<C-W>l')

-- Local list
map('n', '<C-j>', ':lnext<cr>')
map('n', '<C-k>', ':lprevious<cr>')

-- Quick Fix List
map('n', '<M-j>', ':cnext<cr>')
map('n', '<M-k>', ':cprevious<cr>')

-- HopL
map('n', 's', ':HopWord<CR>')

-- Undo Tree
map('n', '<F1>', ':UndotreeToggle<CR>')

-- File Tree
map('n', '<C-n>', ':NvimTreeToggle<CR>')
map('n', '<leader>r', ':NvimTreeRefresh<CR>')
map('n', '<leader>n', ':NvimTreeFindFileToggle<CR>')

-- Telescope
map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>sf', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>ss', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>sc', '<cmd>lua require("telescope.builtin").commands()<cr>')
map('n', '<leader>sgs', '<cmd>lua require("telescope.builtin").git_status()<cr>')
map('n', '<leader>sb', '<cmd>lua require("telescope").buffers()<cr>')

-- Completion
M.attach_completion = function(bufnr)
  local bmap = map_for_buffer(bufnr)
  bmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  bmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bmap('n', 'H', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bmap('n', '<leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bmap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
  bmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  bmap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  bmap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  bmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
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
