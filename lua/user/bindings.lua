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

-- Line Numbers
vim.g.relativenumber = vim.opt.relativenumber
local function toggle_line_numbers()
  vim.g.relativenumber = not vim.g.relativenumber
  vim.opt.relativenumber = vim.g.relativenumber
end

wk.register {['<leader>n'] = {name = 'Linenumbers', t = {toggle_line_numbers, 'Toggle'}}}

-- Local list
wk.register {
  ['<leader>l'] = {
    name = 'Local List',
    j = {'<cmd>lnext<cr>', 'Next LL Item'},
    k = {'<cmd>lprevious<cr>', 'Previous LL Item'},
    q = {'<cmd>lclose<cr>', 'Close List'}
  }
}

-- Quick Fix List
wk.register {
  ['<leader>k'] = {name = 'Quick fix List', q = {'<cmd>cclose<cr>', 'Close List'}},
  ['<M-j>'] = {'<cmd>cnext<cr>', 'Next QL Item'},
  ['<M-k>'] = {'<cmd>cprevious<cr>', 'Previous QL Item'}
}

-- HopL
map('n', 's', '<cmd>HopChar1<CR>')
map('v', 's', '<cmd>HopChar1<CR>')
map('o', 's', '<cmd>HopChar1<CR>')
map('n', 'S', '<cmd>HopWord<CR>')
map('v', 'S', '<cmd>HopWord<CR>')
map('o', 'S', '<cmd>HopWord<CR>')

-- Other
wk.register {['<leader>o'] = {'<cmd>silent exec "!open %:p:h"<CR>', 'Open folder of current file'}}
wk.register {['<leader>R'] = {require'user.reload'.reload, 'Reload vim config'}}
wk.register {['<leader>q'] = {'<cmd>:close<CR>', 'Close Window'}}
wk.register {['<leader>w'] = {'<cmd>:write<CR>', 'Write Window'}}

-- Registers
wk.register {
  ['<leader>r'] = {
    name = 'Registers',
    y = {'<cmd>let @+=@"<CR><cmd>let @*=@"<CR>', 'Copy to system register'}
  }
}

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
    q = {':tabclose<CR>', 'Close Tab'},
    b = {'<C-W>T', 'Open Current Buffer as Tab'}
  }
}

-- File Explorer
local function explorer_reveal_file()
  local path = vim.fn.expand('%:p')
  vim.cmd('Fern . -drawer -width=50 -wait')
  vim.cmd('FernDo FernReveal ' .. path)
end

vim.g['fern#disable_default_mappings'] = true
wk.register {
  ['<leader>e'] = {
    name = 'File Explorer',
    e = {'<cmd>Fern . -drawer -width=50<CR>', 'Open Explorer'},
    f = {explorer_reveal_file, 'Open Explorer and focus current file', silent = false},
    q = {'<cmd>FernDo close<CR>', 'Close Explorer'}
  }
}

M.attach_file_explorer = function()
  local bmap = function(action, name) return {action, name, buffer = vim.fn.bufnr()} end

  wk.register {
    s = bmap('<Plug>(fern-action-mark:toggle)', 'Select'),
    a = bmap('<Plug>(fern-action-new-path)', 'New File/Folder'),
    h = bmap('<Plug>(fern-action-collapse)', 'Collapse'),
    l = bmap('<Plug>(fern-action-expand)', 'Expand'),
    y = bmap('<Plug>(fern-action-yank:path)', 'Yank Path'),
    z = bmap('<Plug>(fern-action-zoom)', 'Zoom'),
    c = bmap('<Plug>(fern-action-clipboard-copy)', 'Copy'),
    m = bmap('<Plug>(fern-action-clipboard-move)', 'Move'),
    p = bmap('<Plug>(fern-action-clipboard-paste)', 'Paste'),
    d = bmap('<Plug>(fern-action-remove)', 'Remove'),
    r = bmap('<Plug>(fern-action-rename)', 'Rename'),
    ['<CR>'] = bmap('<Plug>(fern-action-open-or-enter)', 'Open or Enter'),
    ['<BS>'] = bmap('<Plug>(fern-action-leave)', 'Leave'),
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
    l = {':TestLast<cr>', 'Run previous test again'},
    t = {':TestFile<cr>', 'Run tests in file'},
    n = {':TestNearest<cr>', 'Run test close to cursor'},
    v = {':TestVisit<cr>', 'Run test close to cursor'},
    u = {name = 'Ultitest', t = {':Ultest<cr>', 'Run tests in file'}},
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
    b = {
      function()
        require('telescope.builtin').buffers {sort_lastused = true, ignore_current_buffer = true}
      end, 'Find buffer'
    },
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
      t = {
        name = 'Typescript',
        r = bmapnsilent('<cmd>TSLspRenameFile<CR>', 'Rename TS file'),
        t = bmapnsilent('<cmd>edit %:r.spec.%:e<CR>', 'Create Test')
      }
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
