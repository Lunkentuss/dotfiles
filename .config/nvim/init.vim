" = comments
call plug#begin('~/.config/nvim/plugged')

Plug 'daeyun/vim-matlab'

call plug#end()

set nocompatible
set t_Co=16
syntax on
filetype plugin on

filetype plugin indent on    " required, will use settings from scripts 

" --- Hard tabs ---
set tabstop=4
set shiftwidth=4
set noexpandtab
" --- Hard tabs ---

" --- Soft tabs ---
"set expandtab
"set shiftwidth=2
"set softtabstop=2
" --- Soft tabs ---

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

"------------------VIM------------------------


set background=dark

"color default
"color happy_hacking
"color two-firewatch
"color deep-space
"color ghostbuster
colorscheme solarized


"------------------VIM------------------------

"------------------GVIM-----------------------

" --- GVIM OPTIONS ---
"
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
:set guifont=Monospace\ 14

" --- GVIM OPTIONS ---

" ----- Colors GVIM------
"
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

