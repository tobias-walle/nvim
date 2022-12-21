local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  print('Installing packer')
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path })
  vim.cmd([[packadd packer.nvim]])

  print('Installing packages, please restart afterwards')
  require('user.plugins')
  require('packer').sync()

  return true
end

return false
