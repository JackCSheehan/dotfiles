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

" Statusline
set statusline=%F%m
set statusline+=%=
set statusline+=Ln\ %l/%L\ Col\ %v

" netrw
let g:netrw_liststyle=0
let g:netrw_bufsettings="nolist"
let g:netrw_banner=0
let g:netrw_winsize=17
let g:netrw_browse_split=4
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
colorscheme iceberg
hi LineNr ctermbg=234
hi SpecialKey ctermfg=237

" Callback to get the user's fzf selection and open it in the current buffer
func! FzfCallback(channel, msg)
    try
        " Get the user's selected file
        let file = readfile("/tmp/vim_find")[0]

        " Close the terminal buffer
        call execute("q")

        " Replace the existing buffer with the selected file
        call execute("e " . file)
    catch
        " This could happe if the user presses CTRL+C or force kills the terminal job. We don't want
        " to show an errors in these cases, so we'll ignore the exception
    endtry
endfunc

" Handles fuzzy finding execution
func! FindExecuter()
    " Launch a new terminal running fzf to allow user to fuzzy search files.
    " `to` places the window at the top.
    "
    " The command used for the preview will always show the output of `file` at the top of the
    " preview window but will use `--mime-encoding` to determine whether or not `cat` should be
    " called (i.e., we don't want to `cat` binary files).
    to call term_start(
\       [
\           "fzf",
\           "--preview",
\           "file -b {} && file --mime-encoding {} | grep -qv binary && batcat --color=always --style=numbers {}"
\       ],
\       #{
\           term_name: "fzf",
\           exit_cb: "FzfCallback",
\           out_io: "file",
\           out_name: "/tmp/vim_find",
\           term_finish: "close",
\           term_rows: "25"
\       }
\   )
endfun

" Fuzzy file search
command! Find call FindExecuter()
