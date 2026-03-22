" App launcher in Vim.

func! s:Launcher(app)
    if has("win32")
        call system("start " . a:app)
    else
        call system(a:app)
    endif
endfunc

command! -nargs=1 -complete=shellcmd Launcher :call s:Launcher(<f-args>)
nnoremap <Leader>l :Launcher <Tab>

