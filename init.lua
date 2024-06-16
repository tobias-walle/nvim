vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('user.plugins', {
  defaults = {
    lazy = true,
  },
  dev = {
    path = '~/.local/share/nvim/nix',
    fallback = true,
  },
})

-- Addional options injected by nix
local nixpath = os.getenv('HOME') .. '/.local/share/nvim/nix/init.lua'
if vim.loop.fs_stat(nixpath) then
  dofile(nixpath)
else
  print("Couldn't find " .. nixpath)
end

require('user.core.keymaps')
require('user.core.options')
