" General settings
set nocompatible
filetype on
set cursorline
set cursorlineopt=screenline
set number relativenumber
set scrolloff=12
set belloff=all
set formatoptions+=rj
set formatoptions-=t
set nojoinspaces
set nowrap
set linebreak
set autoread
set errorformat+=%f
set noesckeys
set splitright
set splitbelow
set noshowmatch
set textwidth=100
set wrapmargin=0
set sessionoptions-=options
set noshowcmd
syntax sync fromstart
set viminfo='20,/0,:0,<0,@0,h,s0

" Leader config for custom keybinds.
let mapleader = " "
nnoremap <Space> <Nop>

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
    set guioptions+=cM
    set backspace=indent,eol,start
    set guicursor+=a:blinkon0
    au GUIEnter * set lines=40 columns=140

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
    nnoremap <MiddleMouse> <Nop>
    inoremap <MiddleMouse> <Nop>
    tnoremap <MiddleMouse> <Nop>
    nnoremap <LeftMouse> <Nop>
    inoremap <LeftMouse> <Nop>
    tnoremap <LeftMouse> <Nop>
    nnoremap <RightMouse> <Nop>
    inoremap <RightMouse> <Nop>
    tnoremap <RightMouse> <Nop>

    " Not all terminal emulators support non-ASCII, so only set this for Gvim.
    set fillchars+=vert:│

    " Allow shift-insert to paste from clipboard like in terminal emulators.
    inoremap <S-Insert> <Esc>"+pa
    tnoremap <S-Insert> <C-w>"+

    if has("win32")
        set guifont=JetBrains\ Mono:h10
    else
        set guifont=JetBrains\ Mono\ 10
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
    " Note this depends on the C-Backspace tnoremap later in this file to work.
    tmap <M-d> <M-f><C-backspace>
endif

" Ensure quickfix buffer is always at the bottom and has a default size.
au FileType qf wincmd J | resize 12

" Close Vim if the final buffer is something we don't care to keep open.
au BufEnter * if winnr("$") == 1 && (&ft == "qf" || &ft == "netrw" || &ft == "help") | q | endif

" Ensure windows are equalized when Vim is resized.
au VimResized * wincmd =

" Don't block closing current terminal buffer on running job.
tnoremap <silent> <C-w>c <C-w>:q!<Return>

" Statusline
set laststatus=2
set statusline=%f%m
set statusline+=%=
set statusline+=Ln\ %l/%L\ Col\ %v

" netrw
let g:netrw_liststyle=3
let g:netrw_bufsettings="nolist nomodified statusline=%f bufhidden=delete"
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_preview=1
au FileType netrw nmap <buffer> h -
au FileType netrw nmap <buffer> l <Return>
au FileType netrw vert resize 40
au FileType netrw call execute("file netrw - " . getcwd())
nnoremap <silent> <Leader>e :Lex!<Return>

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

" Help shortcut.
nnoremap <Leader>h :h 

" Buffer shortcut.
nnoremap <Leader>b :b <Tab>

" Custom shortcuts for navigating quickfix list.
nnoremap <silent> <Leader>j :cnext<Return>
nnoremap <silent> <Leader>k :cprev<Return>

" Custom shortcut to jump to column width.
nnoremap <silent> <Leader>$ :call cursor(line("."), &textwidth)<Return>

" Shortcut for running :noh since it gets cumbersome to type all the time.
nnoremap <silent> <Leader>n :noh<Return>

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase
set tagcase=match
set tags=tags
set complete=.,w,b,u
set nocscopetag

" Wildmenu.
set wildmenu
set wildmode=longest:full
if has("patch-8.2.4325")
    set wildoptions=pum
    set pumheight=20
endif
set wildcharm=<Tab>

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
autocmd FileType make setlocal noexpandtab
autocmd FileType go setlocal noexpandtab iskeyword-=.
autocmd FileType bzl setlocal syntax=python
autocmd FileType css,html,make setlocal iskeyword+=-
autocmd BufRead,BufNewFile *.glsl set filetype=c
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

" Support C-Backspace in terminal buffers. Use a function to work around vim interpreting <C-w>
" weirdly on the rhs of a mapping.
func! SendCWTerm()
    call term_sendkeys(bufnr(), "\<C-w>")
endfunc
tnoremap <silent> <C-Backspace> <C-w>:call SendCWTerm()<Return>

" Support C-Backspace in insert mode.
inoremap <C-Backspace> <C-w>

" GNU readline shortcuts in command mode.
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Delete>
cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <C-Backspace> <C-w>

" Allow shift-insert to paste from clipboard like in terminal emulators.
cnoremap <S-Insert> <C-r>+

" Fix delay when switching to below/right window from terminal.
tnoremap <C-w><C-w> <C-w><C-w>

" Shortcuts for splitting terminal buffers.
nnoremap <silent> <C-w>V :vert term<Enter>
tnoremap <silent> <C-w>V <C-w>:vert term<Enter>
nnoremap <silent> <C-w>S :term<Enter>
tnoremap <silent> <C-w>S <C-w>:term<Enter>
tnoremap <silent> <C-w>s <C-w>:new<Enter>
tnoremap <silent> <C-w>v <C-w>:vnew<Enter>
nnoremap <silent> <Leader>t :terminal ++curwin<Enter>

" Tab shortcuts.
nnoremap <silent> <C-w>t :tabnew<Enter>
tnoremap <silent> <C-w>t <C-w>:tabnew<Enter>
nnoremap <silent> <C-w>T :tab term<Enter>
tnoremap <silent> <C-w>T <C-w>:tab term<Enter>
nnoremap <silent> <Tab> gt
nnoremap <silent> <C-w><Tab> gt
tnoremap <silent> <C-w><Tab> <C-w>gt
nnoremap <silent> <S-Tab> gT
nnoremap <silent> <C-w><S-Tab> gT
tnoremap <silent> <C-w><S-Tab> <C-w>gT

" Import external vimfiles
source ~/.vim/vimfiles/vshell.vim
source ~/.vim/vimfiles/tmux.vim
source ~/.vim/vimfiles/review.vim
source ~/.vim/vimfiles/snippets.vim
source ~/.vim/vimfiles/query.vim
source ~/.vim/vimfiles/launch.vim

" Fuzzy file search
func! FindComplete(A, L, P)
    return systemlist("git ls-files \"*" . a:A . "*\"")
endfunc

command! -nargs=1 -complete=customlist,FindComplete Find e <args>
nnoremap <Leader>f :Find 

" Recursive grep
func! GrepImpl(search)
    if trim(a:search) == ""
        return
    endif

    cgete system("git grep -in " . a:search)
    copen
    let w:quickfix_title = a:search
endfunc
command! -nargs=1 -complete=file Grep call GrepImpl(<f-args>)
nnoremap <Leader>g :Grep 

" Load git diff patch file.
func! GitDiff() abort
    enew
    let patch = trim(system("git diff"))
    call setline(1, split(patch, "\n"))
    setlocal filetype=diff nomodifiable nomodified
endfunc
command! -nargs=0 GitDiff call GitDiff(<f-args>)
nnoremap <Leader>d :GitDiff<Cr>

" Run universal ctags.
func! Tags() abort
    call system("ctags --recurse --languages=AnsiblePlaybook,C,C#,C++,CSS,Erlang,Go,Java,JavaScript,Julia,Kotlin,Lua,Matlab,PHP,Perl,PowerShell,Python,PuppetManifest,Ruby,Rust,Terraform,Vim,Sh,TypeScript")
endfunc

