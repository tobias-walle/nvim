vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {}
if not vim.g.vscode then
  table.insert(spec, { import = 'user.plugins' })
else
  table.insert(spec, { import = 'user.plugins.whichkey' })
  table.insert(spec, { import = 'user.plugins.flash' })
  table.insert(spec, { import = 'user.plugins.theme' })
  table.insert(spec, { import = 'user.plugins.mini-trailspace' })
  table.insert(spec, { import = 'user.plugins.conform' })
end

require('lazy').setup({
  spec = spec,
  defaults = {
    lazy = true,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

require('user.core.keymaps')
require('user.core.options')
