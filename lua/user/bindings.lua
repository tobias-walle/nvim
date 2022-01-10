local M = {}

local wk = require('which-key')

-- Utils
local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
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

-- Local list
map('n', '<M-j>', ':lnext<cr>')
map('n', '<M-k>', ':lprevious<cr>')

-- Quick Fix List
map('n', '<M-J>', ':cnext<cr>')
map('n', '<M-K>', ':cprevious<cr>')

-- HopL
map('n', 's', '<cmd>HopChar1<CR>')
map('v', 's', '<cmd>HopChar1<CR>')
map('o', 's', '<cmd>HopChar1<CR>')
map('n', 'S', '<cmd>HopWord<CR>')
map('v', 'S', '<cmd>HopWord<CR>')
map('o', 'S', '<cmd>HopWord<CR>')

-- Nvim Development
wk.register {['<leader>r'] = {require'user.reload'.reload, 'Reload vim config'}}

-- Harpoon
wk.register {
  ['<leader>h'] = {
    name = 'Harpoon',
    h = {function() require('harpoon.mark').add_file() end, 'Add file'},
    m = {function() require('harpoon.ui').toggle_quick_menu() end, 'Quick Menu'}
  },
  -- Navigation
  ['<M-a>'] = {function() require('harpoon.ui').nav_file(1) end, 'Go to File 1'},
  ['<M-s>'] = {function() require('harpoon.ui').nav_file(2) end, 'Go to File 2'},
  ['<M-d>'] = {function() require('harpoon.ui').nav_file(3) end, 'Go to File 3'},
  ['<M-f>'] = {function() require('harpoon.ui').nav_file(4) end, 'Go to File 4'}
}

-- Undo Tree
map('n', '<F1>', ':UndotreeToggle<CR>')

-- Tabs
wk.register {
  t = {
    name = 'Tabs',
    h = {':tabprev<CR>', 'Previous Tab'},
    l = {':tabnext<CR>', 'Next Tab'},
    n = {':tabnew<CR>', 'New Tab'},
    s = {':tab split<CR>', 'Split (Clone) Tab'},
    c = {':tabclose<CR>', 'Close Tab'},
    b = {'<C-W>T', 'Open Current Buffer as Tab'}
  }
}

-- File Explorer
wk.register {
  ['<leader>e'] = {
    name = 'File Explorer',
    e = {':Fern . -drawer<CR>', 'Open Explorer'},
    f = {':Fern . -drawer -reveal=%<CR>', 'Open Explorer and focus current file'},
    c = {':FernDo close<CR>', 'Close Explorer'}
  }
}

M.attach_file_explorer = function()
  local bmap = function(action, name) return {action, name, buffer = vim.fn.bufnr()} end

  wk.register {
    q = bmap('<cmd>q<CR>', 'Quit'),
    l = bmap('<Plug>(fern-action-expand)', 'Expand'),
    s = bmap('<Plug>(fern-action-mark:toggle)', 'Select'),
    ['<C-l>'] = bmap('<C-W>l', 'Right Pane'),
    ['<C-t>'] = bmap('<Plug>(fern-action-open:tabedit)', 'Tabedit'),
    ['<C-v>'] = bmap('<Plug>(fern-action-open:vsplit)', 'Vsplit'),
    ['<C-s>'] = bmap('<Plug>(fern-action-open:split)', 'Hsplit')
  }
end

vim.cmd [[ autocmd FileType fern lua require('user.bindings').attach_file_explorer() ]]

-- Diffs
wk.register {
  ['<leader>d'] = {
    name = 'Diffs',
    g = {':diffget<cr>', 'Apply from other buffer'},
    p = {':diffput<cr>', 'Apply to other buffer'},
    f = {':DiffviewFileHistory<cr>', 'Get see history of current file'},
    c = {':DiffviewOpen <C-r><C-w><cr>', 'Open diff between HEAD and commit under cursor'}
  }
}

-- Git
-- LuaFormatter off
wk.register {
  ['<leader>g'] = {
    name = 'Git',
    s = {':G<cr>', 'Git Status'},
    p = {'<cmd>Gitsigns preview_hunk<CR>', 'Preview Hunk'},
    r = {'<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk'},
    b = {function() require'gitsigns'.blame_line {full = true} end, 'Blame Line'}
  }
}
wk.register({
  ['<leader>g'] = {
    name = 'Git',
    r = {'<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk'},
  }
}, { mode = 'v' })
-- LuaFormatter on

-- Merge
wk.register {
  ['<leader>m'] = {
    name = 'Git Merge',
    t = {':MergetoolToggle<cr>', 'Toggle Mergetool'},
    l = {
      name = 'Layout',
      a = {':MergetoolToggleLayout lmr<cr>', 'Toggle lmr layout'},
      b = {':MergetoolToggleLayout blr,m<cr>', 'Toggle blr,m layout'}
    },
    p = {
      name = 'Preference',
      l = {':MergetoolPreferLocal<cr>', 'Prefer local revision'},
      r = {':MergetoolPreferRemote<cr>', 'Prefer remote revision'}
    }
  }
}

-- Debugging (WIP)
wk.register {
  ['<leader>b'] = {
    name = 'Debugging (WIP)',
    b = {function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint'},
    c = {function() require('dap').continue() end, 'Continue'}
  }
}

-- Testing
wk.register {
  ['<leader>t'] = {
    name = 'Testing',
    s = {':UltestSummary<cr>', 'Toggle Test Summary'},
    q = {':UltestStop<cr>', 'Stop running tests'},
    l = {':UltestLast<cr>', 'Run previous test again'},
    t = {':Ultest<cr>', 'Run tests in file'},
    n = {':UltestNearest<cr>', 'Run test close to cursor'},
    d = {
      name = 'Debug',
      t = {':UltestDebug<cr>', 'Debug tests in file'},
      n = {':UltestDebugNearest<cr>', 'Debug test close to cursor'}
    }
  }
}

-- Search
wk.register {
  ['<leader>s'] = {
    name = 'Search',
    f = {function() require('telescope.builtin').find_files() end, 'Find files'},
    F = {function() require('user.telescope').find_files_all() end, 'Find files (include ignored)'},
    s = {function() require('telescope.builtin').live_grep() end, 'Find text'},
    S = {function() require('user.telescope').live_grep_all() end, 'Find text (include ignored)'},
    r = {function() require('spectre').open_file_search() end, 'Search & Replace in file'},
    R = {function() require('spectre').open() end, 'Search & Replace globally'},
    c = {function() require('telescope.builtin').commands() end, 'Find command'},
    b = {function() require('telescope.builtin').buffers() end, 'Find buffer'},
    p = {function() require('telescope').extensions.projects.projects() end, 'Find buffer'},
    g = {
      name = 'Git',
      s = {function() require('telescope.builtin').git_status() end, 'Find staged files'}
    }
  },
  ['<C-p>'] = {function() require('telescope.builtin').find_files() end, 'Find files'},
  ['?'] = {':nohl<CR>', 'Hide search highlight'}
}

-- Completion
M.attach_completion = function(bufnr)
  local bmap = function(action, name) return {action, name, buffer = bufnr} end
  local bmapnsilent =
    function(action, name) return {action, name, buffer = bufnr, silent = false} end

  wk.register {
    g = {
      name = 'Go to',
      D = bmap(function() vim.lsp.buf.declaration() end, 'Go to declaration'),
      d = bmap(function() vim.lsp.buf.definition() end, 'Go to definition'),
      i = bmap(function() vim.lsp.buf.implementation() end, 'Go to implementation'),
      r = bmap(function() vim.lsp.buf.references() end, 'Go to references')
    },
    ['<leader><leader>'] = {
      name = 'Language Server',
      h = bmap(function() vim.lsp.buf.hover() end, 'Hover'),
      s = bmap(function() vim.lsp.buf.signature_help() end, 'Signature Help'),
      r = bmap(function() vim.lsp.buf.rename() end, 'Rename'),
      a = bmap(function() vim.lsp.buf.code_action() end, 'Code Actions'),
      e = bmap(function() vim.diagnostic.open_float() end, 'Show Errors'),
      q = bmap(function() vim.diagnostic.setloclist() end, 'Save Errors to Loclist'),
      f = bmap(function() vim.lsp.buf.formatting() end, 'Format Buffer'),
      d = bmap(function() vim.lsp.buf.type_definition() end, 'Type Definition'),
      t = {name = 'Typescript', r = bmapnsilent('<cmd>TSLspRenameFile<CR>', 'Rename TS file')}
    }
  }
end

M.cmp_mapping = function(cmp)
  return {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})
  }
end

-- Typescript
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

return M
