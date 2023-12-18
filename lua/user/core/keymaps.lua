-- stylua: ignore start
local M = {}

local wk = require('which-key')
local map = require('user.utils.keymaps').map
local new_cmd = require('user.utils.keymaps').new_cmd

-- Copy/Pasta
map({ 'v', 'n' }, '<Leader>y', '"+y', 'Yank to system clipboard')
map({ 'v', 'n' }, '<Leader>p', '"+p', 'Paste from system clipboard')

-- Resize
map('n', '+', '<C-W>>', 'Increase width of window')
map('n', '-', '<C-W><', 'Decrease width of window')

-- Increment
map('n', '<C-n>', '<C-a>', 'Increment number under cursor')

-- Files
wk.register({ ['<leader>f'] = { name = '+files' } })
map('n', '<leader>fD', '<cmd>!rm %<cr><cmd>bd!<cr>', 'Delete file of current buffer')

-- General
new_cmd('X', function() vim.cmd('wqa') end, 'Save & Close')

new_cmd('W', function()
  vim.cmd('bufdo lua vim.lsp.buf.format()')
  vim.cmd('wa')
end, 'Format & Save')

new_cmd('SpellAddAll', 'let @a = "]Szg" | norm 1000@a', 'Add all words in buffer to spell check white list')

-- Line Numbers
local function toggle_line_numbers()
  vim.opt.relativenumber = not vim.opt.relativenumber.get()
end
new_cmd('ToggleLine', toggle_line_numbers, 'Toggle line numbers')
new_cmd('TL', toggle_line_numbers, 'Toggle line numbers')

-- Neovide
if vim.g.neovide == true then
  -- Zoom
  map('n', '<C-+>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
  map('n', '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
  map('n', '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')
  -- Allow clipboard copy paste in neovim
  vim.g.neovide_input_use_logo = 1
  map('', '<D-v>', '+p<CR>')
  map('!', '<D-v>', '<C-R>+')
  map('t', '<D-v>', '<C-R>+')
  map('v', '<D-v>', '<C-R>+')
end

-- Make
new_cmd(
  'Mtc',
  function() require('user.utils.make').runTypescriptCommand('yarn type-check') end,
  'Run yarn type-check and save result in quickfix list'
)
new_cmd(
  'Mtsc',
  function() require('user.utils.make').runTypescriptCommand('yarn tsc --noEmit') end,
  'Run yarn tsc --noEmit and save result in quickfix list'
)
new_cmd(
  'Mtsb',
  function() require('user.utils.make').runTypescriptCommand('yarn tsc --build') end,
  'Run yarn tsc --build and save result in quickfix list'
)
new_cmd(
  'Mng',
  function() require('user.utils.make').runTypescriptCommand('yarn ng build') end,
  'Run yarn ng build and save result in quickfix list'
)

-- highlight
wk.register({ ['<leader>v'] = { name = '+highlight' } })
map('n', '<leader>vv', '<cmd>nohl<cr>', 'Remove highlight')
map('n', '<leader>vg', 'GVgg', 'Highlight file')

-- Terminal
wk.register({ ['<leader>x'] = { name = '+terminal' } })
map('n', '<leader>xx', '<cmd>vert Ttoggle<cr>', 'Toggle terminal')
map('n', '<leader>xc', '<cmd>Tclear<cr>', 'Clear terminal')
map('n', '<leader>xq', '<cmd>Tclose<cr>', 'Close terminal')
map('n', '<leader>xf', '<cmd>T cd %:p:h<cr><cmd>vert Topen<cr>', 'Change working dir to current file')

-- Lists
map('n', '<M-t>', require('user.utils.quick-fix').toggle_active_list, 'Toggle active list')
map('n', '<M-j>', require('user.utils.quick-fix').next_in_active_list, 'Next QL Item')
map('n', '<M-k>', require('user.utils.quick-fix').previous_in_active_list, 'Previous QL Item')

-- Local list
wk.register({ ['<leader>l'] = { name = '+local list' } })
map('n', '<leader>lo', '<cmd>lopen<cr>', 'Open List')
map('n', '<leader>lq', '<cmd>lclose<cr>', 'Close List')
map('n', '<leader>la', require('user.utils.quick-fix').activate_local_list, 'Activate LL for shortcut')
map(
  'n',
  '<leader>ls',
  '<cmd>g//laddexpr expand("%") . ":" . line(".") . ":" . getline(".")<cr> | <cmd>lopen<cr>',
  'Move current search to local list'
)

-- Quick Fix List
wk.register({ ['<leader>c'] = { name = '+quick fix list' } })
map('n', '<leader>co', '<cmd>copen<cr>', 'Open List')
map('n', '<leader>cq', '<cmd>cclose<cr>', 'Close List')
map('n', '<leader>ca', require('user.utils.quick-fix').activate_quick_fix_list, 'Activate QL for shortcut')

-- Other
map('n', '<leader>o', '<cmd>silent exec "!open %:p:h"<CR>', 'Open folder of current file')
map('n', '<leader><CR>', require('user.utils.reload').reload, 'Reload vim config')
map('n', '<leader>q', '<cmd>:close<CR>', 'Close Window')
map('n', '<leader>w', function()
  require('user.utils.lsp').format()
  vim.cmd('write')
end, 'Write Window')

-- Undo Tree
map('n', '<leader>u', ':UndotreeToggle<CR>', 'Toggle Undo Tree')

-- Tabs
wk.register({ ['t'] = { name = '+tabs' } })
map('n', 'th', ':tabprev<CR>', 'Previous Tab')
map('n', 'tl', ':tabnext<CR>', 'Next Tab')
map('n', 'tn', ':tabnew<CR>', 'New Tab')
map('n', 'te', ':tabedit %<CR>', 'Edit current buffer in a tab')
map('n', 'ts', ':tab split<CR>', 'Split (Clone) Tab')
map('n', 'tq', ':tabclose<CR>', 'Close Tab')
map('n', 'tb', '<C-W>T', 'Open Current Buffer as Tab')

-- Buffers
local close_unused_buffers = require('user.utils.autoclose-unused-buffers').close_unused_buffers

wk.register({ ['<leader>b'] = { name = '+buffers' } })
map('n', '<leader>bc', close_unused_buffers, 'Close unused buffers')

-- Explorer (File/Outline)
wk.register({ ['<leader>e'] = { name = '+explorer' } })
map('n', '<leader>ee', '<cmd>Neotree toggle<CR>', 'Open Explorer')
map('n', '<leader>eo', '<cmd>AerialToggle<CR>', 'Toggle Outline Explorer')
map('n', '<leader>ef', '<cmd>Neotree reveal<CR>', 'Open Explorer and focus current file')
map('n', '<leader>eq', '<cmd>Neotree close<CR>', 'Close Explorer')

-- Diffs
wk.register({ ['<leader>d'] = { name = '+diffs' } })
map('n', '<leader>dg', '<cmd>diffget<cr>', 'Apply from other buffer')
map('n', '<leader>dp', '<cmd>diffput<cr>', 'Apply to other buffer')

-- Git
wk.register({ ['<leader>g'] = { name = '+git' } })
map('n', '<leader>gs', '<cmd>G<cr><cmd>only<cr>', 'Git Status')
map({ 'n', 'v' }, '<leader>gp', function() require('gitsigns').preview_hunk() end, 'Preview Hunk')
map({ 'n', 'v' }, '<leader>gr', function() require('gitsigns').reset_hunk() end, 'Reset Hunk')
map('n', '<leader>gR', '<cmd>silent !git checkout -- %<CR>', 'Reset file')
map('n', '<leader>gx', '<cmd>DiffviewOpen --base=LOCAL<cr>', 'Open diffview against local changes')
map('n', '<leader>gf', '<cmd>DiffviewFileHistory --base=LOCAL %<cr>', 'Get see history of current file')
map('n', '<leader>gc', '<cmd>DiffviewOpen <C-r><C-w><cr>', 'Open diff between HEAD and commit under cursor')
map({ 'n', 'v' }, '<leader>gb', function() require('gitsigns').blame_line({ full = true }) end, 'Blame Line')
map('v', '<leader>gl', ':DiffCommitLine<CR>', 'Show diff of selected lines')

new_cmd(
  'DiffCommitLine',
  "lua require('telescope').extensions.advanced_git_search.diff_commit_line()",
  'Show diff of selected lines',
  { range = true }
)

new_cmd(
  'DiffO',
  function(opts) vim.cmd('DiffviewOpen --base=LOCAL ' .. opts.args) end,
  'Open Diff from locale',
  { nargs = 1 }
)

-- Mergetool
wk.register({ ['<leader>m'] = { name = '+mergetool' } })
map('n', '<leader>mt', '<cmd>MergetoolToggle<cr>', 'Toggle Mergetool')
map('n', '<leader>mla', '<cmd>MergetoolToggleLayout lmr<cr>', 'Toggle lmr layout')
map('n', '<leader>mlA', '<cmd>MergetoolToggleLayout LmR<cr>', 'Toggle LmR layout')
map('n', '<leader>mlb', '<cmd>MergetoolToggleLayout blr,m<cr>', 'Toggle blr,m layout')
map('n', '<leader>mlB', '<cmd>MergetoolToggleLayout BLR,m<cr>', 'Toggle BLR,m layout')
map('n', '<leader>mpl', require('user.utils.mergetool').prefer_local, 'Prefer local revision')
map('n', '<leader>mpr', require('user.utils.mergetool').prefer_remote, 'Prefer remote revision')

-- Luasnip
map({'i', 's'}, '<C-l>', function() require('luasnip').jump(1) end, 'Next Snippet')
map({'i', 's'}, '<C-j>', function() require('luasnip').jump(-1) end, 'Next Snippet')

-- Debugging (WIP)
-- wk.register({ ['<leader>b'] = { name = '+debugging' } })
-- map('n', '<leader>bb', function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint')
-- map('n', '<leader>bc', function() require('dap').continue() end, 'Continue')

-- Testing
wk.register({ ['<leader>t'] = { name = '+testing' } })
map('n', '<leader>tl', '<cmd>Tclear!<cr><cmd>TestLast<cr>', 'Run previous test again')
map('n', '<leader>tt', '<cmd>Tclear!<cr><cmd>TestFile<cr>', 'Run tests in file')
map('n', '<leader>tn', '<cmd>Tclear!<cr><cmd>TestNearest<cr>', 'Run test close to cursor')
map('n', '<leader>tv', '<cmd>Tclear!<cr><cmd>TestVisit<cr>', 'Open test close to cursor')
map('n', '<leader>tu', ':Ultest<cr>', 'Run tests in file (Ultitest)')
map('n', '<leader>tdt', ':UltestDebug<cr>', 'Debug tests in file')
map('n', '<leader>tdn', ':UltestDebugNearest<cr>', 'Debug test close to cursor')

-- Search
map('n', '<C-p>', function() require('telescope.builtin').find_files() end, 'Find files')

wk.register({ ['<leader>s'] = { name = '+search' } })
map('n', '<leader>sb', function() require('user.utils.autoclose-unused-buffers').close_unused_buffers_and_find_buffer() end, 'Find buffer')
map('n', '<leader>scc', function() require('telescope.builtin').commands() end, 'Find command')
map('n', '<leader>sch', function() require('telescope.builtin').search_history() end, 'Search command history')
map('n', '<leader>sd', function() require('telescope.builtin').diagnostics({ severity_limit = vim.diagnostic.severity.WARN }) end, 'Search lsp diagnostics messages/errors in workspace')
map('n', '<leader>se', function() require('telescope').extensions.file_browser.file_browser({ path = vim.fn.expand('%:p:h') }) end, 'Open FileBrowser relative to current path')
map('n', '<leader>sE', function() require('telescope').extensions.file_browser.file_browser() end, 'Open FileBrowser relative to cwd')
map('n', '<leader>sf', function() require('telescope.builtin').find_files() end, 'Find files')
map('n', '<leader>sF', function() require('user.utils.telescope').find_files_all() end, 'Find files (include ignored)')
map('n', '<leader>sg', function() require('telescope.builtin').git_status() end, 'Find staged files')
map('n', '<leader>shh', function() require('telescope').extensions.file_history.history() end, 'Find in file history')
map('n', '<leader>she', function() require('telescope.builtin').help_tags() end, 'Help')
map('n', '<leader>sk', function() require('telescope.builtin').keymaps() end, 'Find keymap')
map('n', '<leader>sn', function() require('telescope').extensions.notify.notify() end, 'Find notifications')
map('n', '<leader>sp', function() require('telescope.builtin').spell_suggest() end, 'Suggest spelling')
map('n', '<leader>sr', function() require('telescope.builtin').lsp_references() end, 'Find references of symbol under cursor')
map('n', '<leader>ss', function() require('user.utils.telescope').live_grep() end, 'Find text with options')
map('n', '<leader>sS', function() require('telescope.builtin').grep_string() end, 'Find string under cursor')
map('n', '<leader>su', function() require('telescope.builtin').resume() end, 'Resume')
map('n', '<leader>sx', function() require('telescope.builtin').builtin() end, 'Prompt Picker')
map('n', '<leader>sy', function() require('telescope').extensions.neoclip.neoclip() end, 'Search clipboard')
map('n', '<leader>sz', function() require('telescope.builtin').lsp_workspace_symbols() end, 'Find workspace symbols')

--- AI
wk.register({ ['<leader>a'] = { name = '+ai' } })
map('n', '<leader>ac', "<cmd>GpContext<cr>", 'Open a context file to provide context information for the project')

map('n', '<leader>ar', "<cmd>GpRewrite<cr>", 'Rewrite line')
map('n', '<leader>aa', "<cmd>GpAppend<cr>", 'Like rewrite but append after selection')
map('n', '<leader>ap', "<cmd>GpPrepend<cr>", 'Like rewrite but prepend before selection')
map('n', '<leader>as', "<cmd>GpVnew<cr>", 'Like rewrite but generate into a vertical split')

map({'v', 'x'}, '<leader>ar', "<cmd>'<,'>GpRewrite<cr>", 'Rewrite selection')
map({'v', 'x'}, '<leader>aa', "<cmd>'<,'>GpAppend<cr>", 'Like rewrite but append after selection')
map({'v', 'x'}, '<leader>ap', "<cmd>'<,'>GpPrepend<cr>", 'Like rewrite but prepend before selection')
map({'v', 'x'}, '<leader>as', "<cmd>'<,'>GpVnew<cr>", 'Like rewrite but generate into a vertical split')

map({'v', 'x'}, '<leader>ai', "<cmd>'<,'>GpImplement<cr>", 'Implement selection')
map({'v', 'x'}, '<leader>ax', "<cmd>'<,'>GpExplain<cr>", 'Explain selection')
map({'v', 'x'}, '<leader>at', "<cmd>'<,'>GpUnit<cr>", 'Generate unit tests for selection')

-- Completion
local function toggle_virtual_lines()
  local config = vim.diagnostic.config()
  if config == nil then
    return
  end
  vim.diagnostic.config({ virtual_lines = not config.virtual_lines })
  vim.diagnostic.config({ virtual_text = not config.virtual_text })
end

M.attach_completion = function()
  wk.register({ ['<leader><leader>'] = { name = '+lsp' } })

  new_cmd('LspRename', function(args)
    require('user.utils.refactor').rename(args.args)
  end, 'Rename syncronously (can be used in macros)', { nargs=1 });

  map('n', 'gD', function() vim.lsp.buf.declaration() end, 'Go to declaration')
  map('n', 'gd', function() vim.lsp.buf.definition() end, 'Go to definition')
  map('n', 'gt', function() vim.lsp.buf.type_definition() end, 'Go to type definitions')
  map('n', 'gi', function() vim.lsp.buf.implementation() end, 'Go to implementation')
  map('n', 'gr', function() vim.lsp.buf.references() end, 'Go to references')

  map('n', '<leader><leader>h', function() vim.lsp.buf.hover() end, 'Hover')
  map('n', '<leader><leader>s', function() vim.lsp.buf.signature_help() end, 'Signature Help')
  map('n', '<leader><leader>r', function() vim.lsp.buf.rename() end, 'Rename')
  map('n', '<leader><leader>R', require('user.utils.refactor').rename_prefix, 'Rename Prefix')
  map({ 'n', 'v' }, '<leader><leader>a', function() vim.lsp.buf.code_action() end, 'Code Actions')
  map('n', '<leader><leader>e', function() vim.diagnostic.open_float() end, 'Show Errors')
  map('n', '<leader><leader>E', '<cmd>RustOpenExternalDocs<cr>', 'Rust External Docs')
  map('n', '<leader><leader>q', function() vim.diagnostic.setloclist() end, 'Save Errors to Loclist')
  map('n', '<leader><leader>f', function() require('user.utils.lsp').format() end, 'Format Buffer')
  map('n', '<leader><leader>d', function() vim.lsp.buf.type_definition() end, 'Type Definition')
  map('n', '<leader><leader>l', function() toggle_virtual_lines() end, 'Toggle diagnostic lines')

  wk.register({ ['<leader><leader>w'] = { name = '+workspaces' } })
  map('n', '<leader><leader>wa', function() vim.lsp.buf.add_workspace_folder() end, 'Add Workspace')
  map('n', '<leader><leader>wd', function() vim.lsp.buf.remove_workspace_folder() end, 'Remove Workspace')
  map('n', '<leader><leader>wl', function() dbg(vim.lsp.buf.list_workspace_folders()) end, 'List Workspaces')

  wk.register({ ['<leader><leader>t'] = { name = '+typescript' } })
  map('n', '<leader><leader>tr', '<cmd>TypescriptRenameFile<CR>', 'Rename TS file')
  map(
    'n',
    '<leader><leader>ti',
    '<cmd>TypescriptAddMissingImports<CR><cmd>TypescriptOrganizeImports<CR>',
    'Import All & Organize Imports'
  )
  map('n', '<leader><leader>tt', '<cmd>edit %:r.spec.%:e<CR>', 'Create TS Test')
end

return M
-- stylua: ignore end
