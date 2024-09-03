" Editor settings
set nocompatible
filetype on
set number relativenumber
set laststatus=2
set scrolloff=20
set cursorline
set cursorlineopt=screenline
set belloff=all

" Statusline
set statusline=%F%m
set statusline+=%=
set statusline+=Ln\ %l/%L\ \(%p%%),\ Col\ %v\ 
set statusline+=%y\ 

" netrw
let g:netrw_liststyle=0
let g:netrw_bufsettings="nolist"
let g:netrw_banner=0
let g:netrw_winsize=17
let g:netrw_browse_split=4
let g:netrw_preview=1
inoremap <CS-e> :Lex! <CR> :set nowrap <CR>h
noremap <CS-e> :Lex! <CR> :set nowrap <CR>h

" Terminal
inoremap <C-t> :bo term ++rows=15<CR>
noremap <C-t> :bo term ++rows=15<CR>

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" Visualize white space characters
set lcs=space:·,tab:→⠀
set list

" Search settings
set incsearch
set hlsearch
set wildmenu
set wildmode=list:longest

" Multi-line comment remap
inoremap /**/ /*<CR><space>*<CR>*/<ESC>ka<space>

" NoOp Ctrl + A to avoid interaction with screen
noremap <C-a> <Nop>
inoremap <C-a> <Nop>

" NoOp arrow keys
noremap <Up> <Nop>
inoremap <Up> <Nop>
noremap <Down> <Nop>
inoremap <Down> <Nop>
noremap <Left> <Nop>
inoremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Right> <Nop>

" File type-specific settings
autocmd FileType make setlocal noexpandtab  " Makefiles require tabs for indentation
autocmd FileType go setlocal noexpandtab    " gofmt enforces tabs
autocmd FileType bzl setlocal syntax=python " Starlark is Python-like, so this gives the best syntax highlighting

let g:onedark_hide_endofbuffer=1
let g:onedark_termcolors=256
let g:onedark_terminal_italics=1
syntax on
colorscheme onedark
