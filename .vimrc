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

" Opens a file in the current buffer given a popup menu and its selection
func! OpenFile(winid, result)
    if a:result < 1
        return
    endif

    let selected_file = getbufline(winbufnr(a:winid), a:result)
    execute "e" selected_file[0]
endfunc

func! SearchFilesFilter(winid, key)
    " We'll let VIM handle certain key combos as it usually would to keep some of the default popup
    " menu behaviors
    if a:key == "\<Enter>" || a:key == "\<Esc>" || a:key == "\<C-n>" || a:key == "\<C-p>"
        call popup_filter_menu(a:winid, a:key)

        " Since the popup menu filter already handled these characters, we don't need VIM to handle
        " them in the editor itself
        return 1
    endif
    
    let options = popup_getoptions(a:winid)

    " Handle backspace
    if a:key == "\<BS>"
        " First 2 chars are the prompt ("> "), so once we've backspaced to the prompt, don't chop
        " off any more characters
        if len(options.title) <= 2
            return 0
        endif
        let options.title = options.title[:-2]

    " All other characters will just get appended to the title
    else
        let options.title = options.title . a:key
    endif

    call popup_setoptions(a:winid, options)

    " Search for files based on the currently-typed query
    " TODO: Replace with job_start to avoid hanging on longer find calls
    let files = split(system("timeout 1s find . -type f -path '*" . options.title[2:] . "*' 2> /dev/null"), "\n")
    
    call popup_settext(a:winid, files)

    return 1
endfunc


" Opens popup menu to show files based on a search string
func! ListFiles()
    call popup_menu("",
\       #{
\           title: "> ",
\           callback: "OpenFile",
\           filter: "SearchFilesFilter",
\           minheight: &lines - 8,
\           maxheight: &lines - 8,
\           minwidth: 100,
\           maxwidth: 100,
\           wrap: 0,
\           border: [0, 0, 0, 0]
\       }
\   )
endfunc

" Fuzzy file search
command! Find call ListFiles()
