" Editor settings
set nocompatible
filetype on
set number relativenumber
set laststatus=2
set scrolloff=20
set belloff=all
set formatoptions+=r
set nowrap
set linebreak
set autoread
au FileChangedShell * checktime
set errorformat+=%f
set noesckeys

" Tags
set tags=tags.swp
au BufWritePost,VimEnter,DirChanged * call Tag()
func! Tag()
    " Use .swp since it's already included in common .gitignore configs.
    silent! !ctags
        \ -R -f $(git rev-parse --show-toplevel 2>/dev/null || echo ~)/tags.swp
        \ .
        \ --exclude=.git
        \ --exclude=node_modules
        \ --exclude=venv
        \ --exclude=".*"
        \ --exclude="__pyache__"
        \ --exclude="bazel-*"
        \ 2> /dev/null &
endfunc

" Statusline
set statusline=%f%m
set statusline+=%=
set statusline+=Ln\ %l/%L\ Col\ %v

" netrw
let g:netrw_liststyle=1
let g:netrw_bufsettings="nolist nomodified"
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_preview=1
au FileType netrw nmap <buffer> h -
au FileType netrw nmap <buffer> l <Return>

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" Visualize white space characters
set lcs=space:·,tab:→⠀

" Search settings
set incsearch
set hlsearch
set wildmenu
set wildmode=list:longest
set ignorecase
set smartcase

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

" NoOp Ctrl + A to avoid interaction with screen/Tmux
noremap <C-a> <Nop>
inoremap <C-a> <Nop>

" Color scheme
colorscheme onedark
set background=dark
set t_Co=256
syntax on

" Fuzzy file search
func! FindImpl(search)
    let search = substitute(a:search, " ", "*", "g")
    cgete system("find . -type f -path '*" . search . "*' ! -path '*venv*' ! -path '*/.*' ! -path '*/__pycache__' ! -path '*/node_modules' ! -path '*/bazel-*' -printf '%P\n' 2>/dev/null")
    copen 25
endfunc
command! -nargs=1 Find call FindImpl(<f-args>)

" Recursive grep
func! GrepImpl(search)
    cgete system("grep -irn " . a:search . " --exclude-dir={venv,node_modules,.*,__pycache__,bazel-*} --exclude=\"*.swp\" --exclude=tags.swp")
    copen 25
endfunc
command! -nargs=1 Grep call GrepImpl(<f-args>)

