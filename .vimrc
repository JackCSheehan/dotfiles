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

" Terminal
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

" Callback for a popup menu to open a file
func! OpenFile(id, result)
    if a:result < 1
        return
    endif

    let selected_file = getbufline(winbufnr(a:id), a:result)
    execute "e" selected_file[0]
endfunc

" Opens popup menu to show files based on given search string
func! ListFiles(search)
    " Find files based on the search
    let files = split(system("find . -type f -name '*" . a:search . "*' 2> /dev/null"), "\n")

    " Show menu for selecting files
    if len(files) == 0
        call popup_menu("No files matching pattern '" . a:search . "'", #{ title: "Files" })
    else
        call popup_menu(files, #{ title: "Files", callback: "OpenFile", maxheight: &lines - 7, wrap: 0, minwidth: 100, maxwidth: 100 })
    endif
endfunc

" Fuzzy file search
command! -nargs=1 -complete=file Find call ListFiles(<q-args>)
