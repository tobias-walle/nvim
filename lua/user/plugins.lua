return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Dependencies
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')
  use('lambdalisue/nerdfont.vim')
  use('lambdalisue/glyph-palette.vim')
  use('MunifTanjim/nui.nvim')

  -- UI
  use('stevearc/dressing.nvim')

  -- treesitter
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  use('nvim-treesitter/nvim-treesitter-textobjects')

  -- Autocompletion & Diagnostics
  use('neovim/nvim-lspconfig')
  use('NoahTheDuke/vim-just') -- Syntax highlighting for justfiles

  use('b0o/schemastore.nvim')

  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('jose-elias-alvarez/null-ls.nvim')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('simrat39/rust-tools.nvim')
  use('mhinz/vim-crates')
  use('saecki/crates.nvim')
  use('jose-elias-alvarez/typescript.nvim')
  use('ray-x/lsp_signature.nvim')
  use('lvimuser/lsp-inlayhints.nvim')

  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')

  use('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

  use('folke/lua-dev.nvim')

  -- Lsp Installation
  use('williamboman/mason.nvim')

  -- Focus Areas
  use('hoschi/yode-nvim')

  -- Help/Docs
  use('folke/which-key.nvim')

  -- Navigation
  use('nvim-telescope/telescope.nvim')
  use('nvim-telescope/telescope-live-grep-args.nvim')
  use('nvim-telescope/telescope-file-browser.nvim')
  use('ThePrimeagen/harpoon')

  -- Undo
  use('simnalamburt/vim-mundo')

  -- Git
  use('lewis6991/gitsigns.nvim')
  use('tpope/vim-fugitive')
  use('samoshkin/vim-mergetool')
  use('sindrets/diffview.nvim')
  -- use('TimUntersberger/neogit')

  -- File Explorer
  use({ 'nvim-neo-tree/neo-tree.nvim', branch = 'v2.x' })

  -- Clipboard
  use('AckslD/nvim-neoclip.lua')

  -- Style
  use('navarasu/onedark.nvim')
  use('folke/tokyonight.nvim')
  use('nvim-lualine/lualine.nvim')
  use('alvarosevilla95/luatab.nvim')

  -- Autoclose brackets
  use('windwp/nvim-autopairs')
  use('windwp/nvim-ts-autotag')

  -- Commands
  use('tpope/vim-surround')
  use('phaazon/hop.nvim')

  -- Tests
  use({ 'vim-test/vim-test', run = ':UpdateRemotePlugins' })

  -- Debugging
  use('mfussenegger/nvim-dap')

  -- Comments
  use('numToStr/Comment.nvim')
  use('JoosepAlviste/nvim-ts-context-commentstring')

  -- Project Config
  use('windwp/nvim-projectconfig')

  -- Scrollbar
  use('petertriho/nvim-scrollbar')

  -- Terminal
  use('kassio/neoterm')

  -- Color Codes
  use({ 'RRethy/vim-hexokinase', run = 'make hexokinase' })

  -- Replace
  use('tpope/vim-abolish')
end)
