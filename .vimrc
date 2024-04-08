" Editor settings
set nocompatible
filetype on
syntax on
set number
set laststatus=2
set scrolloff=20
set cursorline
set cursorlineopt=screenline

" netrw
let g:netrw_liststyle=3 
let g:netrw_bufsettings="nolist"

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

" Colors. Inspired by Gruvbox dark: https://github.com/morhetz/gruvbox
color default
hi SpellBad cterm=reverse ctermbg=NONE ctermfg=red
hi Normal ctermbg=233 ctermfg=223
hi Comment ctermfg=241
hi Constant ctermfg=142
hi PreProc ctermfg=2
hi Statement ctermfg=160
hi Type ctermfg=166
hi Special ctermfg=175
hi Title ctermfg=175
hi SpecialKey ctermfg=235
hi StatusLine ctermbg=246 ctermfg=235
hi StatusLineNC ctermbg=246 ctermfg=235
hi TabLineFill ctermbg=223 ctermfg=233
hi TabLine ctermbg=235 ctermfg=246
hi clear SpellBad 
hi SpellBad cterm=reverse ctermbg=NONE ctermfg=160
hi LineNr ctermfg=238
hi CursorLine cterm=NONE ctermbg=234
hi Directory ctermfg=109
hi IncSearch ctermfg=214 ctermbg=233
hi Search ctermbg=214 ctermfg=233
hi Visual ctermbg=235
hi Todo ctermfg=214 ctermbg=NONE
