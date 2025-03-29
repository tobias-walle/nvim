local opt = vim.opt

-- Options
opt.encoding = 'utf-8'
opt.hidden = true
opt.wrap = false
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smarttab = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.mouse = 'a'
opt.cursorline = true
opt.autoread = true
opt.shortmess = opt.shortmess + 'c'
opt.shell = 'fish'
opt.conceallevel = 0
opt.exrc = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 50
opt.timeoutlen = 250
opt.scrolloff = 15
opt.showtabline = 1
opt.guifont = 'JetBrainsMono Nerd Font'
opt.spelllang = 'en,de'
opt.spell = true
opt.spellcapcheck = ''
opt.undofile = true

-- START: Folding
-- Basic folding configuration
vim.o.foldlevelstart = 99 -- Start with all folds open
vim.o.foldenable = false -- Disable folding by default
vim.o.foldmethod = 'expr' -- Use expression-based folding

-- Default to treesitter folding when available
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})

-- Custom fold text display
function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return line .. ' ····· ' .. line_count .. ' lines '
end

-- Apply custom fold text and styling
vim.opt.foldtext = 'v:lua.custom_fold_text()'
opt.fillchars = opt.fillchars + 'fold:·' -- Custom fold character
-- END: Folding

-- Enable the display of whitespace characters
opt.list = true
---@diagnostic disable-next-line: missing-fields
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·', -- Show trailing spaces as dots
  nbsp = '␣', -- Character to represent non-breaking spaces
}

-- see https://github.com/sindrets/diffview.nvim/issues/35
opt.fillchars = opt.fillchars + 'diff:╱'

-- Do not let the editorconfig change the EOL style (Git is already managing that)
require('editorconfig').properties.end_of_line = nil

vim.cmd([[set formatoptions-=o]])
local general_options_au_group =
  vim.api.nvim_create_augroup('general_options', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter' }, {
  pattern = '*',
  group = general_options_au_group,
  callback = function()
    -- Folding
    -- Disable autocomments
    vim.opt.formatoptions:remove('o')
  end,
})

-- Fix .env files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.env.*',
  callback = function() vim.bo.filetype = 'sh' end,
})

-- Allow comments in json files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.json',
  callback = function() vim.bo.filetype = 'jsonc' end,
})

-- Check for changes on focus/buffer enter
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    if vim.fn.bufexists('[Command Line]') == 0 and vim.fn.mode() ~= 'c' then
      vim.cmd.checktime()
    end
  end,
})

vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
  },
})

-- Init some utils
require('user.utils.autoclose-unused-buffers').setup()
