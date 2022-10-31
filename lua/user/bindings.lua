local M = {}

local wk = require('which-key')

-- Utils
local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

-- Leader
map('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Copy/Pasta
map('v', '<Leader>y', '"+y')

-- Pane Switching
map('n', '<C-j>', '<C-W>j')
map('n', '<C-k>', '<C-W>k')
map('n', '<C-h>', '<C-W>h')
map('n', '<C-l>', '<C-W>l')

-- Increment
map('n', '<C-n>', '<C-a>')

-- Files
wk.register({
  ['<leader>f'] = {
    name = 'Files',
    D = { '<cmd>!rm %<cr><cmd>bd!<cr>', 'Delete file of current buffer' },
  },
})

-- General
vim.api.nvim_create_user_command('X', 'wqa', { desc = 'Close & Save' })

-- Line Numbers
local function toggle_line_numbers()
  vim.opt.relativenumber = not vim.opt.relativenumber._value
end

vim.api.nvim_create_user_command('ToggleLine', toggle_line_numbers, { desc = 'Toggle line numbers' })
vim.api.nvim_create_user_command('TL', toggle_line_numbers, { desc = 'Toggle line numbers' })

-- Terminal
wk.register({
  ['<leader>x'] = {
    name = 'Terminal',
    x = { '<cmd>Ttoggle<cr>', 'Toggle terminal' },
    c = { '<cmd>Tclear<cr>', 'Clear terminal' },
    f = { '<cmd>T cd %:p:h<cr>', 'Change working dir to current file' },
  },
})

-- Lists
local active_list = 'quick_fix'

local function activate_list(list)
  print('Activate ' .. list)
  active_list = list
end

local function toggle_active_list()
  local list
  if active_list == 'quick_fix' then
    list = 'local'
  elseif active_list == 'local' then
    list = 'quick_fix'
  end
  print('Activate ' .. list)
  active_list = list
end

local function cmd(cmd_to_run)
  local ok, result = pcall(vim.cmd, cmd_to_run)
  print(result)
end

local function next_in_active_list()
  if active_list == 'quick_fix' then
    cmd([[ cnext ]])
  elseif active_list == 'local' then
    cmd([[ lnext ]])
  end
end

local function previous_in_active_list()
  if active_list == 'quick_fix' then
    cmd([[ cprevious ]])
  elseif active_list == 'local' then
    cmd([[ lprevious ]])
  end
end

wk.register({
  ['<M-t>'] = { toggle_active_list, 'Toggle active list' },
  ['<M-j>'] = { next_in_active_list, 'Next QL Item' },
  ['<M-k>'] = { previous_in_active_list, 'Previous QL Item' },
})

-- Local list
wk.register({
  ['<leader>l'] = {
    name = 'Local List',
    a = {
      function()
        activate_list('local')
      end,
      'Activate LL for shortcut',
    },
    j = { '<cmd>lnext<cr>', 'Next LL Item' },
    k = { '<cmd>lprevious<cr>', 'Previous LL Item' },
    q = { '<cmd>lclose<cr>', 'Close List' },
  },
})

-- Quick Fix List
wk.register({
  ['<leader>c'] = {
    name = 'Quick fix List',
    a = {
      function()
        activate_list('quick_fix')
      end,
      'Activate QL for shortcut',
    },
    q = { '<cmd>cclose<cr>', 'Close List' },
  },
})

-- HopL
map('n', 's', '<cmd>HopWord<CR>')
map('v', 's', '<cmd>HopWord<CR>')
map('o', 's', '<cmd>HopWord<CR>')
map('n', 'S', '<cmd>HopChar1<CR>')
map('v', 'S', '<cmd>HopChar1<CR>')
map('o', 'S', '<cmd>HopChar1<CR>')

-- Other
wk.register({ ['<leader>o'] = { '<cmd>silent exec "!open %:p:h"<CR>', 'Open folder of current file' } })
wk.register({ ['<leader><CR>'] = { require('user.reload').reload, 'Reload vim config' } })
wk.register({ ['<leader>q'] = { '<cmd>:close<CR>', 'Close Window' } })
wk.register({
  ['<leader>w'] = { '<cmd>lua vim.lsp.buf.format()<CR><cmd>:write<CR>', 'Write Window' },
})

-- Registers
wk.register({ ['<leader>r'] = { '<cmd>let @+=@"<CR><cmd>let @*=@"<CR>', 'Copy to system register' } })

-- Harpoon
wk.register({
  ['<leader>h'] = {
    name = 'Harpoon',
    h = {
      function()
        require('harpoon.mark').add_file()
      end,
      'Add file',
    },
    m = {
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      'Quick Menu',
    },
  },
  -- Navigation
  ['<M-a>'] = {
    function()
      require('harpoon.ui').nav_file(1)
    end,
    'Go to File 1',
  },
  ['<M-s>'] = {
    function()
      require('harpoon.ui').nav_file(2)
    end,
    'Go to File 2',
  },
  ['<M-d>'] = {
    function()
      require('harpoon.ui').nav_file(3)
    end,
    'Go to File 3',
  },
  ['<M-f>'] = {
    function()
      require('harpoon.ui').nav_file(4)
    end,
    'Go to File 4',
  },
})

-- Undo Tree
map('n', '<leader>u', ':MundoToggle<CR>')

-- Tabs
wk.register({
  t = {
    name = 'Tabs',
    h = { ':tabprev<CR>', 'Previous Tab' },
    l = { ':tabnext<CR>', 'Next Tab' },
    n = { ':tabnew<CR>', 'New Tab' },
    s = { ':tab split<CR>', 'Split (Clone) Tab' },
    q = { ':tabclose<CR>', 'Close Tab' },
    b = { '<C-W>T', 'Open Current Buffer as Tab' },
  },
})

-- File Explorer
wk.register({
  ['<leader>e'] = {
    name = 'File Explorer',
    e = {
      function()
        require('telescope').extensions.file_browser.file_browser()
      end,
      'Open FileBrowser relative to cwd',
    },
    f = {
      function()
        require('telescope').extensions.file_browser.file_browser({ path = vim.fn.expand('%:p:h') })
      end,
      'Open FileBrowser',
    },
    n = {
      name = 'Neotree',
      e = { '<cmd>Neotree toggle<CR>', 'Open Explorer' },
      f = { '<cmd>Neotree reveal<CR>', 'Open Explorer and focus current file', silent = false },
      q = { '<cmd>Neotree close<CR>', 'Close Explorer' },
    },
  },
})

-- Diffs
wk.register({
  ['<leader>d'] = {
    name = 'Diffs',
    g = { '<cmd>diffget<cr>', 'Apply from other buffer' },
    p = { '<cmd>diffput<cr>', 'Apply to other buffer' },
    l = { '<cmd>vnew +read\\ # | windo diffthis<cr>', 'Diff with local file' },
  },
})

-- Git
-- LuaFormatter off
wk.register({
  ['<leader>g'] = {
    name = 'Git',
    s = { '<cmd>G<cr><cmd>only<cr>', 'Git Status' },
    p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview Hunk' },
    r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk' },
    R = { '<cmd>G checkout -- %<CR>', 'Reset file' },
    x = { '<cmd>DiffviewOpen --base=LOCAL<cr>', 'Open diffview against local changes' },
    f = { '<cmd>DiffviewFileHistory --base=LOCAL %<cr>', 'Get see history of current file' },
    c = { '<cmd>DiffviewOpen <C-r><C-w><cr>', 'Open diff between HEAD and commit under cursor' },
    b = {
      function()
        require('gitsigns').blame_line({ full = true })
      end,
      'Blame Line',
    },
  },
})
wk.register({
  ['<leader>g'] = {
    name = 'Git',
    r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk' },
  },
}, { mode = 'v' })
-- LuaFormatter on

-- Merge
wk.register({
  ['<leader>m'] = {
    name = 'Git Merge',
    t = { ':MergetoolToggle<cr>', 'Toggle Mergetool' },
    l = {
      name = 'Layout',
      a = { ':MergetoolToggleLayout lmr<cr>', 'Toggle lmr layout' },
      b = { ':MergetoolToggleLayout blr,m<cr>', 'Toggle blr,m layout' },
    },
    p = {
      name = 'Preference',
      l = { ':MergetoolPreferLocal<cr>', 'Prefer local revision' },
      r = { ':MergetoolPreferRemote<cr>', 'Prefer remote revision' },
    },
  },
})

-- Debugging (WIP)
wk.register({
  ['<leader>b'] = {
    name = 'Debugging (WIP)',
    b = {
      function()
        require('dap').toggle_breakpoint()
      end,
      'Toggle Breakpoint',
    },
    c = {
      function()
        require('dap').continue()
      end,
      'Continue',
    },
  },
})

-- Testing
wk.register({
  ['<leader>t'] = {
    name = 'Testing',
    l = { '<cmd>Tclear!<cr><cmd>TestLast<cr>', 'Run previous test again' },
    t = { '<cmd>Tclear!<cr><cmd>TestFile<cr>', 'Run tests in file' },
    n = { '<cmd>Tclear!<cr><cmd>TestNearest<cr>', 'Run test close to cursor' },
    v = { '<cmd>Tclear!<cr><cmd>TestVisit<cr>', 'Run test close to cursor' },
    u = { name = 'Ultitest', t = { ':Ultest<cr>', 'Run tests in file' } },
    d = {
      name = 'Debug',
      t = { ':UltestDebug<cr>', 'Debug tests in file' },
      n = { ':UltestDebugNearest<cr>', 'Debug test close to cursor' },
    },
  },
})

-- Search
wk.register({
  ['<leader>s'] = {
    name = 'Search',
    u = {
      function()
        require('telescope.builtin').resume()
      end,
      'Resume',
    },
    f = {
      function()
        require('telescope.builtin').find_files()
      end,
      'Find files',
    },
    F = {
      function()
        require('user.telescope').find_files_all()
      end,
      'Find files (include ignored)',
    },
    s = {
      function()
        require('user.telescope').live_grep()
      end,
      'Find text with options',
    },
    c = {
      function()
        require('telescope.builtin').commands()
      end,
      'Find command',
    },
    e = {
      function()
        require('telescope').extensions.file_browser.file_browser({ path = vim.fn.expand('%:p:h') })
      end,
      'Open FileBrowser relative to current path',
    },
    E = {
      function()
        require('telescope').extensions.file_browser.file_browser()
      end,
      'Open FileBrowser relative to cwd',
    },
    y = {
      function()
        require('telescope').extensions.neoclip.neoclip()
      end,
      'Find command',
    },
    b = {
      function()
        require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })
      end,
      'Find buffer',
    },
    g = {
      name = 'Git',
      s = {
        function()
          require('telescope.builtin').git_status()
        end,
        'Find staged files',
      },
    },
  },
  ['<C-p>'] = {
    function()
      require('telescope.builtin').find_files()
    end,
    'Find files',
  },
  ['?'] = { ':nohl<CR>', 'Hide search highlight' },
})

local function toggle_virtual_lines()
  local config = vim.diagnostic.config()
  if config == nil then
    return
  end
  vim.diagnostic.config({ virtual_lines = not config.virtual_lines })
  vim.diagnostic.config({ virtual_text = not config.virtual_text })
end

-- Completion
local refactor = require('user.utils.refactor')
M.attach_completion = function(bufnr)
  local bmap = function(action, name)
    return { action, name, buffer = bufnr }
  end
  local bmapnsilent = function(action, name)
    return { action, name, buffer = bufnr, silent = false }
  end

  wk.register({
    g = {
      name = 'Go to',
      D = bmap(function()
        vim.lsp.buf.declaration()
      end, 'Go to declaration'),
      d = bmap(function()
        vim.lsp.buf.definition()
      end, 'Go to definition'),
      i = bmap(function()
        vim.lsp.buf.implementation()
      end, 'Go to implementation'),
      r = bmap(function()
        vim.lsp.buf.references()
      end, 'Go to references'),
    },
    ['<leader><leader>'] = {
      name = 'Language Server',
      h = bmap(function()
        vim.lsp.buf.hover()
      end, 'Hover'),
      s = bmap(function()
        vim.lsp.buf.signature_help()
      end, 'Signature Help'),
      r = bmap(function()
        vim.lsp.buf.rename()
      end, 'Rename'),
      R = bmap(refactor.rename_prefix, 'Rename Prefix'),
      a = bmap(function()
        vim.lsp.buf.code_action()
      end, 'Code Actions'),
      e = bmap(function()
        vim.diagnostic.open_float()
      end, 'Show Errors'),
      q = bmap(function()
        vim.diagnostic.setloclist()
      end, 'Save Errors to Loclist'),
      f = bmap(function()
        vim.lsp.buf.formatting()
      end, 'Format Buffer'),
      d = bmap(function()
        vim.lsp.buf.type_definition()
      end, 'Type Definition'),
      l = bmap(function()
        toggle_virtual_lines()
      end, 'Toggle diagnostic lines'),
      w = {
        name = 'Workspaces',
        a = bmapnsilent(function()
          vim.lsp.buf.add_workspace_folder()
        end, 'Add Workspace'),
        d = bmapnsilent(function()
          vim.lsp.buf.remove_workspace_folder()
        end, 'Remove Workspace'),
        l = bmapnsilent(function()
          dbg(vim.lsp.buf.list_workspace_folders())
        end, 'List Workspaces'),
      },
      t = {
        name = 'Typescript',
        r = bmapnsilent('<cmd>TypescriptRenameFile<CR>', 'Rename TS file'),
        i = bmapnsilent(
          '<cmd>TypescriptAddMissingImports<CR><cmd>TypescriptOrganizeImports<CR>',
          'Import All & Organize Imports'
        ),
        t = bmapnsilent('<cmd>edit %:r.spec.%:e<CR>', 'Create Test'),
      },
    },
  })
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require('luasnip')

M.cmp_mapping = function(cmp)
  return {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-n>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-p>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
  }
end

wk.register({ ['<C-E>'] = { '<Plug>luasnip-next-choice', 'Next Snippet' } }, { mode = 'i' })
wk.register({ ['<C-E>'] = { '<Plug>luasnip-next-choice', 'Next Snippet' } }, { mode = 's' })

-- Typescript
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

return M
