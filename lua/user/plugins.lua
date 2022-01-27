return require'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Dependencies
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'lambdalisue/nerdfont.vim'
  use 'lambdalisue/glyph-palette.vim'

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
  use 'ahmedkhalf/project.nvim'

  -- Undo
  use 'mbbill/undotree'

  -- Git
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  use 'samoshkin/vim-mergetool'
  use 'sindrets/diffview.nvim'

  -- File Explorer
  use 'lambdalisue/fern.vim'
  use 'lambdalisue/fern-hijack.vim'
  use 'lambdalisue/fern-renderer-nerdfont.vim'

  -- Clipboard
  use 'AckslD/nvim-neoclip.lua'

  -- Style
  use 'navarasu/onedark.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'alvarosevilla95/luatab.nvim'

  -- Autoclose brackets
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  -- Commands
  use 'tpope/vim-surround'
  use 'phaazon/hop.nvim'

  -- Tests
  use {'rcarriga/vim-ultest', requires = {'vim-test/vim-test'}, run = ':UpdateRemotePlugins'}

  -- Debugging
  use 'mfussenegger/nvim-dap'

  -- Comments
  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
end)
