" Editor settings
set nocompatible
filetype on
syntax on
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
let g:netrw_liststyle=3 
let g:netrw_bufsettings="nolist"
let g:netrw_banner=0

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
inoremap /** /**<CR><space>*<CR>*/<ESC>ka<space>

" Nop Ctrl + A to avoid interaction with screen
noremap <C-a> <Nop>
inoremap <C-a> <Nop>

" Nop arrow keys
noremap <Up> <Nop>
inoremap <Up> <Nop>
noremap <Down> <Nop>
inoremap <Down> <Nop>
noremap <Left> <Nop>
inoremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Right> <Nop>

" Colors. Inspired by Gruvbox dark: https://github.com/morhetz/gruvbox
" SteelBlue1 (81)
" LightGreen (120)
" IndianRed1 (203)
" SandyBrown (215)
" Gold1 (220)
hi clear
syntax reset
set background=dark
set t_Co=256
hi Normal ctermbg=234 ctermfg=255

hi Cursorline cterm=None ctermbg=235
hi Visual ctermfg=None ctermbg=235
hi SpecialKey ctermfg=239
hi EndOfBuffer ctermfg=234
hi Ignore ctermfg=255

hi StatusLine ctermfg=255 ctermbg=239 cterm=None
hi StatusLineNC ctermfg=255 ctermbg=235 cterm=None

hi TabLineFill ctermfg=239
hi TabLine ctermbg=239 cterm=None
hi TabLineSel ctermbg=234 ctermfg=255 cterm=None

hi Comment ctermfg=245
hi LineNr ctermfg=245

hi Statement ctermfg=215
hi PreProc ctermfg=215
hi Identifier ctermfg=215 cterm=None
hi Title ctermfg=215
hi Type ctermfg=203
hi Constant ctermfg=120
hi Special ctermfg=81
hi MatchParen ctermbg=245

hi Todo ctermfg=220 ctermbg=234 cterm=None
hi WildMenu ctermbg=220
hi Search ctermbg=220 ctermfg=234
hi SpellBad ctermbg=203 ctermfg=234
hi Error ctermbg=234 ctermfg=203 cterm=reverse

hi Pmenu ctermbg=239 ctermfg=255
hi PmenuSbar ctermbg=239 ctermfg=255
hi PmenuSel ctermbg=255 ctermfg=239

hi Directory ctermfg=81
