" Editor settings
set nocompatible
filetype on
set number relativenumber
set laststatus=2
set scrolloff=20
set cursorline
set cursorlineopt=screenline
set belloff=all
set formatoptions+=r
set nowrap
set linebreak
set autoread
set noea
set errorformat+=%f

" Statusline
set statusline+=%f%m
set statusline+=%=
set statusline+=Ln\ %l/%L\ Col\ %v

" netrw
let g:netrw_liststyle=0
let g:netrw_bufsettings="nolist"
let g:netrw_banner=0
let g:netrw_winsize=17
let g:netrw_browse_split=0
let g:netrw_preview=1
noremap <CS-e> :Lex! <CR> h

" Prevent terminals from blocking closing with :qa
cnoreabbrev term term ++kill=hup

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
set ignorecase
set smartcase

" NoOp Ctrl + A to avoid interaction with screen
noremap <C-a> <Nop>
inoremap <C-a> <Nop>

" Allow navigating through soft line wraps
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

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
autocmd FileType make setlocal noexpandtab       " Makefiles require tabs for indentation
autocmd FileType go setlocal noexpandtab         " gofmt enforces tabs
autocmd FileType bzl setlocal syntax=python      " Starlark is Python-like, so this gives the best syntax highlighting
autocmd BufRead,BufNewFile *.glsl set filetype=c " GLSL is C-like, so this gives the best syntax highlighting
autocmd FileType markdown setlocal wrap

" Color scheme
syntax on
set background=dark
colorscheme retrobox
hi SpecialKey ctermfg=237

" Fuzzy file search
func! FindImpl(search)
    let search = substitute(a:search, " ", "*", "g")
    cgete system("find . -type f -path '*" . search . "*' ! -path '*venv*' ! -path '*/.*' ! -path '*/__pycache__' ! -path '*/node_modules' ! -path '*/bazel-*' -printf '%P\n' 2>/dev/null")
    copen 25
endfunc

command! -nargs=1 Find call FindImpl(<f-args>)

" Recursive grep
func! GrepImpl(search)
    cgete system("grep -irn " . a:search . " --exclude-dir={venv,node_modules,.*,__pycache__,bazel-*}")
    copen 25
endfunc

command! -nargs=1 Grep call GrepImpl(<f-args>)
