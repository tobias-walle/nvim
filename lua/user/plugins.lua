return require'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Dependencies
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Autocompletion & Diagnostics
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'neovim/nvim-lspconfig'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'simrat39/rust-tools.nvim'
  use 'mhinz/vim-crates'
  use {'saecki/crates.nvim', tag = 'v0.1.0'}
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use 'ray-x/lsp_signature.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'folke/trouble.nvim'

  -- Help/Docs
  use 'folke/which-key.nvim'

  -- Navigation
  use 'nvim-telescope/telescope.nvim'
  use 'ThePrimeagen/harpoon'
  use 'windwp/nvim-spectre'

  -- Undo
  use 'mbbill/undotree'

  -- Git
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  use 'samoshkin/vim-mergetool'
  use 'sindrets/diffview.nvim'

  -- File Explorer
  use 'kyazdani42/nvim-tree.lua'

  -- Clipboard
  use 'AckslD/nvim-neoclip.lua'

  -- Style
  use 'navarasu/onedark.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'alvarosevilla95/luatab.nvim'

  -- Autoclose brackets
  use 'windwp/nvim-autopairs'

  -- Commands
  use 'tpope/vim-surround'
  use 'phaazon/hop.nvim'

  -- Tests
  use {'rcarriga/vim-ultest', requires = {'vim-test/vim-test'}, run = ':UpdateRemotePlugins'}
end)
