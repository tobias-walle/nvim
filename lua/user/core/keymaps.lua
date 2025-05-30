-- stylua: ignore start
local M = {}

local wk = require('which-key')
local map = require('user.utils.keymaps').map
local new_cmd = require('user.utils.keymaps').new_cmd

-- Copy/Pasta
map({ 'v', 'n' }, '<leader>y', '"+y', 'Yank to system clipboard')
map({ 'v', 'n' }, '<leader>p', '"+p', 'Paste from system clipboard')

-- Navigate
map({'n', 't'}, '<C-j>', '<cmd>NavigatorDown<cr>', 'Navigate to a different split')
map({'n', 't'}, '<C-k>', '<cmd>NavigatorUp<cr>', 'Navigate to a different split')
map({'n', 't'}, '<C-h>', '<cmd>NavigatorLeft<cr>', 'Navigate to a different split')
map({'n', 't'}, '<C-l>', '<cmd>NavigatorRight<cr>', 'Navigate to a different split')

-- Resize
map('n', '+', '<C-W>>', 'Increase width of window')
map('n', '-', '<C-W><', 'Decrease width of window')

-- Increment
map('n', '<C-n>', '<C-a>', 'Increment number under cursor')

-- Profiler
map('n', '<leader>p', '"+p', 'Paste from system clipboard')

-- General
new_cmd('X', function() vim.cmd('wqa') end, 'Save & Close')

new_cmd('W', function()
  vim.cmd('bufdo lua vim.lsp.buf.format()')
  vim.cmd('wa')
end, 'Format & Save')

new_cmd('SpellAddAll', 'let @a = "]Szg" | norm 1000@a', 'Add all words in buffer to spell check white list')

-- Line Numbers
local function toggle_line_numbers()
  local tab = vim.fn.tabpagenr()
  vim.cmd('tabdo windo set relativenumber!')
  vim.cmd.tabnext(tab)
end
new_cmd('ToggleLine', toggle_line_numbers, 'Toggle line numbers')
new_cmd('TL', toggle_line_numbers, 'Toggle line numbers')
map('n', '<leader>L', toggle_line_numbers, 'Toggle line numbers')

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
  function() require('user.utils.make').runTypescriptCommand('pnpm typecheck') end,
  'Run yarn type-check and save result in quickfix list'
)
new_cmd(
  'Mtsc',
  function() require('user.utils.make').runTypescriptCommand('pnpm tsc --noEmit') end,
  'Run yarn tsc --noEmit and save result in quickfix list'
)
new_cmd(
  'Mtsb',
  function() require('user.utils.make').runTypescriptCommand('pnpm tsc --build') end,
  'Run yarn tsc --build and save result in quickfix list'
)
new_cmd(
  'Mng',
  function() require('user.utils.make').runTypescriptCommand('pnpm ng build') end,
  'Run yarn ng build and save result in quickfix list'
)

-- highlight
wk.add({ { '<leader>v', group = '+highlight' } })
map('n', '<leader>vv', '<cmd>nohl<cr>', 'Remove highlight')
map('n', '<leader>vg', 'GVgg', 'Highlight file')

-- Notifications
wk.add({ { '<leader>n', group = '+notifications' } })
map('n', '<leader>nh', '<cmd>Noice<cr>', 'Notification History')

-- Terminal
wk.add({ { '<leader>x', group = '+terminal' } })
map('n', '<leader>xx', '<cmd>vert Ttoggle<cr>', 'Toggle terminal')
map('n', '<leader>xc', '<cmd>Tclear<cr>', 'Clear terminal')
map('n', '<leader>xq', '<cmd>Tclose<cr>', 'Close terminal')
map('n', '<leader>xf', '<cmd>T cd %:p:h<cr><cmd>vert Topen<cr>', 'Change working dir to current file')

-- Lists
map('n', '<M-t>', require('user.utils.quick-fix').toggle_active_list, 'Toggle active list')
map('n', '<M-j>', require('user.utils.quick-fix').next_in_active_list, 'Next QL Item')
map('n', '<M-k>', require('user.utils.quick-fix').previous_in_active_list, 'Previous QL Item')

-- Local list
wk.add({ { '<leader>l', group = '+local list' } })
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
wk.add({ { '<leader>c', group = '+quick fix list' } })
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

-- Tabs & Testing
wk.add({ { '<leader>t', group = '+tabs+testing' } })
map('n', '<leader>th', ':tabprev<CR>', 'Previous Tab')
map('n', '<leader>tl', ':tabnext<CR>', 'Next Tab')
map('n', '<leader>tn', ':tabnew<CR>', 'New Tab')
map('n', '<leader>te', ':tab split<CR>', 'Edit current buffer in a tab')
map('n', '<leader>tq', ':tabclose<CR>', 'Close Tab')
map('n', '<leader>tb', '<C-W>T', 'Open Current Buffer as Tab')

-- Testing
wk.add({ { '<leader>tt', group = '+testing' } })
map('n', '<leader>ttl', '<cmd>Tclear!<cr><cmd>TestLast<cr>', 'Run previous test again')
map('n', '<leader>ttt', '<cmd>Tclear!<cr><cmd>TestFile<cr>', 'Run tests in file')
map('n', '<leader>ttn', '<cmd>Tclear!<cr><cmd>TestNearest<cr>', 'Run test close to cursor')
map('n', '<leader>ttv', '<cmd>Tclear!<cr><cmd>TestVisit<cr>', 'Open test close to cursor')
map('n', '<leader>ttu', ':Ultest<cr>', 'Run tests in file (Ultitest)')
map('n', '<leader>ttdt', ':UltestDebug<cr>', 'Debug tests in file')
map('n', '<leader>ttdn', ':UltestDebugNearest<cr>', 'Debug test close to cursor')

-- Buffers
local close_unused_buffers = require('user.utils.autoclose-unused-buffers').close_unused_buffers

wk.add({ { '<leader>b', group = '+buffers' } })
map('n', '<leader>bc', close_unused_buffers, 'Close unused buffers')

-- Explorer (File/Outline)
wk.add({ { '<leader>e', group = '+explorer' } })
map('n', '<leader>ee', function()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if not explorer then
    Snacks.explorer()
  else
    explorer:close()
  end
end, 'File Explorer')
map('n', '<leader>eo', '<cmd>AerialToggle<CR>', 'Outline Explorer')

map('n', '-', function ()
  Snacks.picker.explorer({
    auto_close = true,
    layout = { preset = "default" },
  })
end, 'Open Explorer in full screen')

-- Diffs
wk.add({ { '<leader>d', group = '+diffs' } })
map('n', '<leader>dg', '<cmd>diffget<cr>', 'diffget - Apply diff from other buffer')
map('v', '<leader>dg', ':\'<,\'>diffget<cr>', 'diffget - Apply diff from other buffer')
map('n', '<leader>dp', '<cmd>diffput<cr>', 'diffput - Apply diff to other buffer')
map('v', '<leader>dp', ':\'<,\'>diffput<cr>', 'diffput - Apply diff from other buffer')

-- Git
wk.add({ { '<leader>g', group = '+git' } })
map({ 'n', 'v' }, '<leader>gp', function() require('gitsigns').preview_hunk() end, 'Preview Hunk')
map({ 'n', 'v' }, '<leader>gr', function() require('gitsigns').reset_hunk() end, 'Reset Hunk')
map('n', '<leader>gR', '<cmd>silent !git checkout -- %<CR>', 'Reset file')
map('n', '<leader>gf', '<cmd>DiffviewOpen --base=LOCAL -- %<cr><cmd>DiffviewToggleFiles<cr>', 'See changes of current file')
map('n', '<leader>gh', '<cmd>DiffviewFileHistory --base=LOCAL %<cr>', 'Get see history of current file')
map('n', '<leader>gc', '<cmd>DiffviewOpen <C-r><C-w><cr>', 'Open diff between HEAD and commit under cursor')
map({ 'n', 'v' }, '<leader>gb', function() require('gitsigns').blame_line({ full = true }) end, 'Blame Line')
map('v', '<leader>gl', ':DiffCommitLine<CR>', 'Show diff of selected lines')
map('n', '<leader>gm', function() require('user.utils.git').insert_git_log_message() end, 'Choose one of the last log messages and insert it to the buffer.')

map('n', '<C-g>', function() Snacks.lazygit() end, 'Lazygit')
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local term_title = vim.b.term_title
    if term_title and term_title:match("lazygit") then
      vim.keymap.set("t", "<C-g>", "<cmd>close<cr>", { buffer = true })
    end
  end,
})

-- Jira
map('n', '<leader>js', function() require('user.utils.jira').selectJiraIssue() end, 'Select a jira issue of the current sprint')
map('n', '<leader>jm', function() require('user.utils.jira').selectJiraIssue('AND assignee = currentUser() AND status != \'Done\'') end, 'Select a jira issues of the current sprint assigned to me')

new_cmd(
  'DiffO',
  function(opts) vim.cmd('DiffviewOpen --base=LOCAL ' .. opts.args) end,
  'Open Diff from locale',
  { nargs = '?' }
)

-- Mergetool
wk.add({ { '<leader>m', group = '+mergetool' } })
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
-- wk.add({ { '<leader>b', group = '+debugging' } })
-- map('n', '<leader>bb', function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint')
-- map('n', '<leader>bc', function() require('dap').continue() end, 'Continue')


-- Search & Find
map('n', '<leader>,', function() Snacks.picker.buffers() end, 'Buffers')
map('n', '<leader>/', function() Snacks.picker.grep() end, 'Grep')
map('n', '<leader>:', function() Snacks.picker.command_history() end, 'Command History')

wk.add({ { '<leader>s', group = '+find' } })
map('n', '<leader>fb', function() Snacks.picker.buffers() end, 'Buffers')
map('n', '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, 'Find Config File')
map('n', '<leader>ff', function() Snacks.picker.smart() end, 'Smart Find Files')
map('n', '<leader>fs', function() Snacks.picker.files() end, 'Find Files')
map('n', '<leader>fg', function() Snacks.picker.git_files() end, 'Find Git Files')
map('n', '<leader>fp', function() Snacks.picker.projects() end, 'Projects')
map('n', '<leader>fr', function() Snacks.picker.recent() end, 'Recent')
map('n', '<C-p>', function() Snacks.picker.smart() end, 'Smart find Files')

wk.add({ { '<leader>s', group = '+search' } })
map('n', '<leader>s"', function() Snacks.picker.registers() end, 'Registers')
map('n', '<leader>s/', function() Snacks.picker.search_history() end, 'Search History')
map('n', '<leader>sa', function() Snacks.picker.autocmds() end, 'Autocmds')
map('n', '<leader>sb', function() Snacks.picker.lines() end, 'Buffer Lines')
map('n', '<leader>sc', function() Snacks.picker.command_history() end, 'Command History')
map('n', '<leader>sC', function() Snacks.picker.commands() end, 'Commands')
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, 'Diagnostics')
map('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, 'Buffer Diagnostics')
map('n', '<leader>sh', function() Snacks.picker.help() end, 'Help Pages')
map('n', '<leader>sH', function() Snacks.picker.highlights() end, 'Highlights')
map('n', '<leader>si', function() Snacks.picker.icons() end, 'Icons')
map('n', '<leader>sj', function() Snacks.picker.jumps() end, 'Jumps')
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, 'Keymaps')
map('n', '<leader>sl', function() Snacks.picker.loclist() end, 'Location List')
map('n', '<leader>sm', function() Snacks.picker.marks() end, 'Marks')
map('n', '<leader>sM', function() Snacks.picker.man() end, 'Man Pages')
map('n', '<leader>sp', function() Snacks.picker.lazy() end, 'Search for Plugin Spec')
map('n', '<leader>sq', function() Snacks.picker.qflist() end, 'Quickfix List')
map('n', '<leader>sR', function() Snacks.picker.resume() end, 'Resume')
map('n', '<leader>su', function() Snacks.picker.undo() end, 'Undo History')
map('n', '<leader>uC', function() Snacks.picker.colorschemes() end, 'Colorschemes')
map('n', '<leader>ss', function() Snacks.picker.grep() end, 'Grep')
map('n', '<leader>so', function() Snacks.picker.lsp_symbols() end, 'LSP Symbols')
map('n', '<leader>sO', function() Snacks.picker.lsp_workspace_symbols() end, 'LSP Workspace Symbols')

map({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, 'Visual selection or word')
wk.add({ { '<leader>sg', group = '+git' } })
map('n', '<leader>sgb', function() Snacks.picker.git_branches() end, 'Git Branches')
map('n', '<leader>sgl', function() Snacks.picker.git_log() end, 'Git Log')
map('n', '<leader>sgL', function() Snacks.picker.git_log_line() end, 'Git Log Line')
map('n', '<leader>sgs', function() Snacks.picker.git_status() end, 'Git Status')
map('n', '<leader>sgS', function() Snacks.picker.git_stash() end, 'Git Stash')
map('n', '<leader>sgd', function() Snacks.picker.git_diff() end, 'Git Diff (Hunks)')
map('n', '<leader>sgf', function() Snacks.picker.git_log_file() end, 'Git Log File')

-- Replace
wk.add({ { '<leader>r', group = '+replace' } })
map('n', '<leader>rr', function() require('spectre').toggle() end, 'Toggle Spectre')
map('n', '<leader>rw', function() require('spectre').open_visual({select_word=true}) end, 'Search current word')
map('v', '<leader>rw', function() vim.cmd('esc') require('spectre').open_visual() end, 'Search current word')
map('n', '<leader>rf', function() require('spectre').open_file_search({select_word=true}) end, 'Search on current file')

--- AI
local map = require('user.utils.keymaps').map
map({'i'}, '<C-z>', function() require('ai').trigger_completion() end)
map('n', '<Leader>aa', '<cmd>AiChat<cr>')
map('n', '<Leader>am', '<cmd>AiChangeModels<cr>')
map('n', '<Leader>ap', function()
  vim.ui.input({ prompt = "Prompt" }, function(input)
    if input then
      vim.cmd("AiChat " .. input)
    end
  end)
end)
map('v', '<Leader>aa', "<esc><cmd>'<,'>AiChat<cr>")
map('v', '<Leader>ap', function()
  vim.ui.input({ prompt = "Prompt" }, function(input)
    if input then
      vim.cmd("'<,'>AiChat " .. input)
    end
  end)
end)
map('v', '<Leader>ar', function()
  vim.ui.input({ prompt = "Prompt" }, function(input)
    if input then
      vim.cmd("'<,'>AiRewrite " .. input)
    end
  end)
end)

-- Completion
local function toggle_virtual_lines()
  local config = vim.diagnostic.config()
  if config == nil then
    return
  end
  vim.diagnostic.config({
    virtual_lines = config.virtual_text,
    virtual_text = not config.virtual_text,
  })
end

M.attach_completion = function()
  wk.add({ { '<leader><leader>', group = '+lsp' } })

  new_cmd('LspRename', function(args)
    require('user.utils.refactor').rename(args.args)
  end, 'Rename syncronously (can be used in macros)', { nargs=1 });

  map('n', 'gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
  map('n', 'gD', function() Snacks.picker.lsp_declarations() end, 'Goto Declaration')
  map('n', 'gr', function() Snacks.picker.lsp_references() end, 'References', { nowait = true })
  map('n', 'gI', function() Snacks.picker.lsp_implementations() end, 'Goto Implementation')
  map('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, 'Goto Type Definition')

  map('n', ']r', function() Snacks.words.jump(1, true) end, 'Jump to next reference')
  map('n', '[r', function() Snacks.words.jump(-1, true) end, 'Jump to prev reference')

  map('n', '<leader><leader>i', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, 'Toggle inlay hints')
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

  wk.add({ { '<leader><leader>w', group = '+workspaces' } })
  map('n', '<leader><leader>wa', function() vim.lsp.buf.add_workspace_folder() end, 'Add Workspace')
  map('n', '<leader><leader>wd', function() vim.lsp.buf.remove_workspace_folder() end, 'Remove Workspace')
  map('n', '<leader><leader>wl', function() dbg(vim.lsp.buf.list_workspace_folders()) end, 'List Workspaces')

  wk.add({ { '<leader><leader>t', group = '+typescript' } })
  map('n', '<leader><leader>tr', '<cmd>TSToolsRenameFile<CR>', 'Rename TS file')
  map('n', '<leader><leader>ti', '<cmd>TSToolsAddMissingImports<CR>', 'Import missing')
  map('n', '<leader><leader>tu', '<cmd>TSToolsRemoveUnusedImports<CR>', 'Remove unused imports')
  map('n', '<leader><leader>tt', '<cmd>edit %:r.spec.%:e<CR>', 'Create TS Test')
end

return M
-- stylua: ignore end
