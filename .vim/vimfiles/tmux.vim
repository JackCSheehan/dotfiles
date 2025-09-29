" Tmux emulation.
func! TmuxImpl(session_name)
    set noswapfile
    set autochdir
    set showtabline=2
    set laststatus=0
    set noruler
    set fillchars=vert:│,stl:─,stlnc:─
    set statusline=─

    func! TmuxTabLine() closure
        let s = "%#TabLine#" .. a:session_name .. " | "
        for i in range(tabpagenr("$"))
            if i + 1 == tabpagenr()
              let s ..= "%#TabLineSel#"
            else
              let s ..= "%#TabLine#"
            endif

            let s ..= "%" .. (i + 1) .. "T"
            let s ..= (i + 1) .. " "
        endfor

        let s ..= "%#TabLineFill#%T"

        return s
    endfunc
    set tabline=%!TmuxTabLine()

    " Default to opening a terminal
    term ++curwin

    " Deconflict with nested vim window shortcuts
    set termwinkey=<C-a>

    " Terminal splits
    tnoremap <silent> <C-a>v <C-a>:vert term<CR>
    tnoremap <silent> <C-a>s <C-a>:term<CR>
    tnoremap <silent> <C-a>c <C-a>:tab term<CR>
    tnoremap <C-a><C-a> <C-a>g<Tab>

    " Tab switching
    tnoremap <C-a>1 <C-a>1gt
    tnoremap <C-a>2 <C-a>2gt
    tnoremap <C-a>3 <C-a>3gt
    tnoremap <C-a>4 <C-a>4gt
    tnoremap <C-a>5 <C-a>5gt
    tnoremap <C-a>6 <C-a>6gt
    tnoremap <C-a>7 <C-a>7gt
    tnoremap <C-a>8 <C-a>8gt
    tnoremap <C-a>9 <C-a>9gt
    tnoremap <C-a>n <C-a>gt
    tnoremap <C-a>p <C-a>gT
    tnoremap <C-a>0 <C-a>:tabfirst<CR>
    tnoremap <C-a>$ <C-a>:tablast<CR>

    " Closing terminals
    tnoremap <C-a>& <C-a>:tabc!<CR>
    tnoremap <C-a>x <C-a>:q!<CR>
    command! KillSession :qa!
    command! KillPane :tabc!

    " Detach
    tnoremap <C-a>d <C-a>:suspend<CR>
endfunc
command! -nargs=1 Tmux call TmuxImpl(<f-args>)

