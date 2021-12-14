call plug#begin()
" Dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Autocompletion & Completion
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'simrat39/rust-tools.nvim'
Plug 'saecki/crates.nvim', { 'tag': 'v0.1.0' }
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'sindrets/diffview.nvim'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim' 

" File Explorer
Plug 'kyazdani42/nvim-tree.lua'

" Statusbar
Plug 'nvim-lualine/lualine.nvim' 

" Themes
Plug 'joshdick/onedark.vim'

" Autoclose brackets
Plug 'windwp/nvim-autopairs'

" Commands
Plug 'tpope/vim-surround' 
Plug 'phaazon/hop.nvim'

call plug#end()

" Plugin Setup
lua require'lualine'.setup()
lua require'hop'.setup()
lua require'nvim-autopairs'.setup()

" Theming
set termguicolors
syntax on
colorscheme onedark
hi Normal guibg=NONE ctermbg=NONE


" Pane Switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nmap s :HopWord<CR>

" General Config
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set copyindent
set number
set relativenumber
set mouse=a

set pastetoggle=<F2>

" Reload Config Shortcut
command Reload :source $MYVIMRC

" Copy/Paste
vmap('<Leader>y', '"+y')

" Other
source $HOME/.config/nvim/cfg/treesitter.lua
source $HOME/.config/nvim/cfg/explorer.vim
source $HOME/.config/nvim/cfg/completion.vim
source $HOME/.config/nvim/cfg/telescope.vim
source $HOME/.config/nvim/cfg/git.vim
