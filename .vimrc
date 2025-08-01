" Editor settings
set nocompatible
filetype on
set cursorline
set cursorlineopt=screenline
set number relativenumber
set laststatus=2
set scrolloff=20
set belloff=all
set formatoptions+=r
set nowrap
set linebreak
set autoread
set errorformat+=%f
set noesckeys
au FileType qf wincmd J
au CursorHold * checktime
set timeoutlen=1000

" Gvim settings
if has("gui_running")
    set guioptions -=m
    set guioptions -=T
    set guioptions -=r
    set guioptions -=L
    set guioptions -=e
    set clipboard=unnamedplus
endif

" Buffer shortcuts
nnoremap bn :bn<CR>
nnoremap bp :bp<CR>
nnoremap bl :ls<CR>:b

" Quickfix shortcuts
nnoremap qn :cn<CR>
nnoremap qp :cp<CR>
nnoremap qo :co<CR>
nnoremap qc :ccl<CR>

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
noremap <C-b> :Lex! %:p:h <CR> h
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
    cgete system("rg -in " . a:search . " --vimgrep")
    copen 25
endfunc
command! -nargs=1 Grep call GrepImpl(<f-args>)

" Diff review for PR reviews. Call from command line directly with 'vim -c Review'
func! ReviewImpl()
    let current_branch = trim(system("git branch --show-current"))
    let default_remote_branch = trim(system("git symbolic-ref refs/remotes/origin/HEAD --short"))
    let git_diff_range = default_remote_branch . "..." . current_branch
    let patch = trim(system("git diff -W " . git_diff_range))

    " If no diff to show, do not proceed
    if len(patch) == 0
        return
    endif

    " Helper function which is called on all file name matches in a patch to add them to the
    " location list.
    func! PopulateLocList() closure
        let line_number = line(".")
        let line = getline(".")

        " Git marks the start of a file in a patch like so:
        " diff --git a/Makefile b/Makefile
        " Use regex to extract the file's name. We'll take the second file name in the line since that
        " will capture file renames.
        let file_name = matchlist(line, 'b/\(.*\)$')[1]

        " Append this file position to the location list.
        call setloclist(0, [], "a", {"items": [{"text": file_name, "bufnr": bufnr(""), "lnum": line_number}]})
    endfunc

    " Put the patch into the current buffer
    call setline(1, split(patch, "\n"))

    " Configure the diff buffer
    setlocal filetype=diff nomodifiable nomodified

    " Show diff summary info in the status line.
    let diff_shortstat = trim(system("git diff " . git_diff_range . " --shortstat"))
    call setbufvar("", "&statusline", "Diff for " . git_diff_range . " | " . diff_shortstat)

    " Use the global command to run PopulateLocList for every file found in the patch
    execute("g/^diff --git a/call PopulateLocList()")

    " Open location list and set a friendly statusline name title
    lopen 10
    call setbufvar("", "&statusline", "Modified files")
endfunc
command! Review call ReviewImpl()

" Generate a tags file
au BufWritePost,VimEnter,DirChanged * call TagsImpl()
func! TagsImpl()
    call system('(ctags -R --exclude=".*" --exclude="__*" --exclude="*venv" --exclude="bazel-*" --exclude="node_modules" --languages="C,C++,Python,Rust,JavaScript,Go,Vim" -f tags.swp && mv tags.swp tags && rm tags.swp) &')
endfunc
command! Tags call TagsImpl()

