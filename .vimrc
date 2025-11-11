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

    set shell=powershell

    " GNU readline-like keybinds for use in the Windows shells.
    tnoremap <C-a> <Home>
    tnoremap <C-e> <End>
    tnoremap <C-f> <Right>
    tnoremap <C-b> <Left>
    tnoremap <C-p> <Up>
    tnoremap <C-n> <Down>
    tnoremap <C-d> <Delete>
    tnoremap <C-c> <C-c><Esc>
endif

" Gvim settings
if has("gui_running")
    " General Gvim settings.
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guioptions-=e
    set guioptions+=c
    set backspace=indent,eol,start
    set guicursor+=a:blinkon0

    " Disable the mouse.
    set mouse=
    nnoremap <ScrollWheelUp> <Nop>
    inoremap <ScrollWheelUp> <Nop>
    tnoremap <ScrollWheelUp> <Nop>
    nnoremap <ScrollWheelDown> <Nop>
    inoremap <ScrollWheelDown> <Nop>
    tnoremap <ScrollWheelDown> <Nop>
    nnoremap <ScrollWheelLeft> <Nop>
    inoremap <ScrollWheelLeft> <Nop>
    tnoremap <ScrollWheelLeft> <Nop>
    nnoremap <ScrollWheelRight> <Nop>
    inoremap <ScrollWheelRight> <Nop>
    tnoremap <ScrollWheelRight> <Nop>

    " Not all terminal emulators support non-ASCII, so only set this for Gvim.
    set fillchars+=vert:│

    " Allow shift-insert to paste from clipboard like in terminal emulators.
    inoremap <S-Insert> <Esc>"+pa
    tnoremap <S-Insert> <C-w>"+

    if has("win32")
        set guifont=JetBrains\ Mono:h11
    else
        set guifont=JetBrains\ Mono\ 11
    endif

    " Make Gvim title the current working directory.
    func! SetTitleString()
        let &titlestring = substitute(getcwd(), expand("~"), "~", "g")
    endfunc
    call SetTitleString()
    au DirChanged * call SetTitleString()

    " Gvim's embedded terminal doesn't support these GNU readline shortcuts even on Linux.
    tnoremap <M-f> <C-Right>
    tnoremap <M-b> <C-Left>
endif

" Ensure quickfix buffer is always at the bottom and has a default size.
au FileType qf wincmd J | resize 12

" Ensure windows are equalized when Vim is resized.
au VimResized * wincmd =

" Don't block closing current terminal buffer on running job.
tnoremap <C-w>c <C-w>:q!<Return>

" Don't block making current window the only one on jobs running in other windows' terminal buffers.
nnoremap <C-w>o :only!<Return>
tnoremap <C-w>o <C-w>:only!<Return>

" Statusline
set laststatus=2
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

" Color scheme
colorscheme onedark
set background=dark
set t_Co=256
syntax on

" Don't block quit on running terminals.
au TerminalWinOpen * call term_setkill(bufnr(), "kill")

" Fix keybinds that insert control characters into terminal buffers.
tnoremap <S-Space> <Space>
tnoremap <C-Return> <Return>
tnoremap <C-Backspace> <Backspace>

" Fix delay when switching to prev window from terminal.
tnoremap <C-w><C-w> <C-w><C-w>

" Shortcuts for splitting terminal buffers.
nnoremap <C-w>V :vert term<Enter>
tnoremap <C-w>V <C-w>:vert term<Enter>
nnoremap <C-w>S :term<Enter>
tnoremap <C-w>S <C-w>:term<Enter>
tnoremap <C-w>s <C-w>:new<Enter>
tnoremap <C-w>v <C-w>:vnew<Enter>

" Tab shortcuts.
nnoremap <C-w>t :tabnew<Enter>
tnoremap <C-w>t <C-w>:tabnew<Enter>
nnoremap <C-w>T :tab term<Enter>
tnoremap <C-w>T <C-w>:tab term<Enter>
nnoremap <Tab> gt
nnoremap <C-w><Tab> gt
tnoremap <C-w><Tab> <C-w>gt
nnoremap <S-Tab> gT
nnoremap <C-w><S-Tab> gT
tnoremap <C-w><S-Tab> <C-w>gT

" Import external vimfiles
source ~/.vim/vimfiles/vshell.vim
source ~/.vim/vimfiles/tmux.vim
source ~/.vim/vimfiles/review.vim
source ~/.vim/vimfiles/sessions.vim

" Fuzzy file search
func! FindImpl(search)
    ccl
    let search = substitute(a:search, " ", "*", "g")
    cgete system("git ls-files \"*" . search . "*\"")
    copen
    let w:quickfix_title = search
endfunc
command! -nargs=1 -complete=file Find call FindImpl(<f-args>)

" Recursive grep
func! GrepImpl(search)
    if trim(a:search) == ""
        return
    endif

    ccl
    cgete system("git grep -in " . a:search)
    copen
    let w:quickfix_title = a:search

    " Search grep term so that it's highlighted in the quickfix list.
    let highlight_search = trim(split(a:search, "--")[0])
    let @/ = highlight_search
    silent! normal! n
    redraw!
endfunc
command! -nargs=1 -complete=file Grep call GrepImpl(<f-args>)

