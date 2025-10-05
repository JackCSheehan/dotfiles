" General settings
set nocompatible
filetype on
set cursorline
set cursorlineopt=screenline
set number relativenumber
set scrolloff=15
set belloff=all
set formatoptions+=r
set nowrap
set linebreak
set autoread
set errorformat+=%f
set noesckeys
set splitright
set splitbelow
set noshowmatch
set textwidth=0
set wrapmargin=0
set sessionoptions-=options

if has("win32")
    " This path is not set by default in Windows, so add it to make it align with Linux.
    set runtimepath+=~/.vim
endif

" Gvim settings
if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guioptions-=e
    set backspace=indent,eol,start
    set guicursor+=a:blinkon0

    " Allow shift-insert to paste from clipboard like in terminal emulators.
    inoremap <S-Insert> <Esc>"+pa
    tnoremap <S-Insert> <C-w>"+

    if has("win32")
        set guifont=JetBrains\ Mono:h15
    else
        set guifont=JetBrains\ Mono\ 15
    endif
endif

" Ensure quickfix buffer is always at the bottom and has a default size.
au FileType qf wincmd J | resize 25

" Ensure windows are equalized when Vim is resized.
au VimResized * wincmd =

" Make C-c work the same as c to close in windcmds.
nnoremap <C-w><C-c> <C-w>c
tnoremap <C-w><C-c> <C-w>c

" Statusline
set laststatus=2
set statusline=%{g:project_name!=''?'['.g:project_name.']\ ':''}%f%m
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

" Open help in a vertical split.
au FileType help wincmd L

" Search settings
set incsearch
set hlsearch
set wildmenu
set wildmode=list:longest
set ignorecase
set smartcase
set tagcase=match
set tags=tags
set complete=.,w,b,u
set nocscopetag

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
autocmd FileType rst setlocal wrap

" NoOp Ctrl + A to avoid interaction with screen/Tmux
noremap <C-a> <Nop>
inoremap <C-a> <Nop>

" Buffer management
nnoremap <C-b> <Nop>
tnoremap <C-b> <Nop>
nnoremap <C-b><C-l> :ls<Return>:b
tnoremap <C-b><C-l> <C-w>:ls<Return>:b
nnoremap <C-b><C-n> :bn<Return>
tnoremap <C-b><C-n> <C-w>:bn<Return>
nnoremap <C-b><C-p> :bp<Return>
tnoremap <C-b><C-p> <C-w>:bp<Return>
nnoremap <C-b><C-b> :b#<Return>
tnoremap <C-b><C-b> <C-w>:b#<Return>

" Color scheme
colorscheme onedark
set background=dark
set t_Co=256
syntax on

" Don't block quit on running terminals.
au TerminalWinOpen * call term_setkill(bufnr(), "kill")

" Make cwd match the current buffer.
au TerminalWinOpen * call term_sendkeys(bufnr(), "cd " . expand("#:h") . "\nclear || cls\n")

" NoOp keybinds that insert control characters into terminal buffers.
tnoremap <S-Space> <Nop>
tnoremap <C-Return> <Nop>

" Fix delay when switching to prev window from terminal.
tnoremap <C-w><C-w> <C-w><C-w>

" Don't block closing terminals on running jobs.
tnoremap <C-w><C-c> <C-w>:q!<Return>
tnoremap <C-w>c <C-w>:q!<Return>

" Shortcuts for splitting terminal buffers.
nnoremap <C-w>V :vert term<Enter>
tnoremap <C-w>V <C-w>:vert term<Enter>
nnoremap <C-w>S :term<Enter>
tnoremap <C-w>S <C-w>:term<Enter>

" Tab shortcuts.
nnoremap <C-w>t :tabnew<Enter>
tnoremap <C-w>t <C-w>:tabnew<Enter>
nnoremap <Tab> gt
tnoremap <C-w><Tab> <C-w>gt
nnoremap <S-Tab> gT
tnoremap <C-w><S-Tab> <C-w>gT

" Import external vimfiles
source ~/.vim/vimfiles/project.vim
source ~/.vim/vimfiles/vshell.vim
source ~/.vim/vimfiles/tmux.vim
source ~/.vim/vimfiles/review.vim

" Fuzzy file search
func! Find()
    ccl
    let search = input("Find wildcard: ")
    let search = substitute(search, " ", "*", "g")
    cgete system("find . -type f -path '*" . search . "*' ! -path '*venv*' ! -path '*/.*' ! -path '*/__pycache__' ! -path '*/node_modules' ! -path '*/bazel-*' -printf '%P\n' 2>/dev/null")
    copen
endfunc
nnoremap <C-f> :call Find()<Return>
tnoremap <C-f> <C-w>:call Find()<Return>

" Recursive grep
func! Grep()
    ccl
    let search = input("Grep input: ")
    cgete system("grep -irn " . search)
    copen
endfunc
nnoremap <C-g> :call Grep()<Return>
tnoremap <C-g> <C-w>:call Grep()<Return>

