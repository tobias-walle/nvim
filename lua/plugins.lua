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
  use {'saecki/crates.nvim', tag = 'v0.1.0'}
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use 'ray-x/lsp_signature.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'folke/trouble.nvim'

  -- Fuzzy Finder
  use 'nvim-telescope/telescope.nvim'

  -- Undo
  use 'mbbill/undotree'

  -- Git
  use 'sindrets/diffview.nvim'
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- File Explorer
  use 'kyazdani42/nvim-tree.lua'

  -- Statusbar
  use 'nvim-lualine/lualine.nvim'

  -- Themes
  use 'navarasu/onedark.nvim'

  -- Autoclose brackets
  use 'windwp/nvim-autopairs'

  -- Search & Replace
  use 'windwp/nvim-spectre'

  -- Commands
  use 'tpope/vim-surround'
  use 'phaazon/hop.nvim'
end)
