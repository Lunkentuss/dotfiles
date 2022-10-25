call plug#begin('~/.config/nvim/plugged')

Plug 'abdalrahman-ali/vim-remembers'
Plug 'daeyun/vim-matlab'
Plug 'dense-analysis/ale'
Plug 'LnL7/vim-nix'
Plug 'tpope/vim-commentary'
Plug 'udalov/kotlin-vim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Java autocomplete
" set pyxversion=3
" let g:pymode_python = 'python3'
" Plug 'artur-shaik/vim-javacomplete2'
" autocmd FileType ja/telescope.nvimva setlocal omnifunc=javacomplete#Complete

call plug#end()

set nocompatible
set t_Co=16
syntax on
filetype plugin on

let mapleader = "," " map leader to comma. Default '\'

filetype plugin indent on    " required, will use settings from scripts

" --- Hard tabs ---
" set tabstop=4
" set shiftwidth=4
" set noexpandtab
" --- Hard tabs ---

" --- Soft tabs ---
set expandtab
set shiftwidth=2
set softtabstop=2
" --- Soft tabs ---

augroup languageSpecific
autocmd!
" autocmd FileType swift set tw=119 sw=4 ts=4
" autocmd FileType python,java,sql,rust set tw=79 sw=4 ts=4
" autocmd FileType c,cc,h set et tw=79 sw=2 ts=2
" autocmd FileType asciidoc setlocal commentstring=//\\ %s
" autocmd FileType html set tw=120
autocmd FileType go set tw=79 sw=2 ts=2 noet
autocmd FileType make set ts=4
augroup END

" --- Clipboard register settings ---
" Differentiates on different systems (+ or *)
vnoremap <C-c> "+y
"vnoremap <C-c> "*y
vnoremap <C-v> "+p
"vnoremap <C-v> "*p
" --- Clipboard register settings ---

set number

" highlight search, use :noh to remove highlights after search
set incsearch

" set autoread
" Dosn't work? Supposed to read automatic when a file is changed
set hlsearch

" Mappings to handling multiple windows in vim(used with vim -p)
" nnoremap <C-S-tab> :tabprevious<CR>
" nnoremap <C-tab>   :tabnext<CR>
" nnoremap <C-t>     :tabnew<CR>
" inoremap <C-S-tab> <Esc>:tabprevious<CR>i
" inoremap <C-tab>   <Esc>:tabnext<CR>i
" inoremap <C-t>     <Esc>:tabnew<CR>
" nnoremap <C-w>     :tabclose<CR>
" inoremap <C-w>     <Esc>:tabclose<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

set background=dark

"color default
"color happy_hacking
"color two-firewatch
"color deep-space
"color ghostbuster
colorscheme solarized

" --- GVIM OPTIONS ---
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
:set guifont=Monospace\ 14

" --- GVIM OPTIONS ---

" ----- Colors GVIM------
if has('gui_running')
	set background=dark

	"color default
	"color happy_hacking
	"color two-firewatch
	"color deep-space
	"color ghostbuster
	colorscheme solarized
endif

" ----- Colors GVIM------

