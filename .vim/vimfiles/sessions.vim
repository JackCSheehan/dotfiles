" Session management.

" Ensure a session directory is always created.
let sessions_dir = expand("~/.vim/sessions/")
call mkdir(sessions_dir, "p")

" Handle completion of session files.
func! SessionComplete(A, L, P)
    return globpath(g:sessions_dir, "*", 0, 1)
endfunc

" Create a new session.
command! -nargs=1 -complete=customlist,SessionComplete Mks :mksession! <args>

" Load an existing session.
command! -nargs=1 -complete=customlist,SessionComplete Sos :so <args>

" Load an existing session.
command! -nargs=1 -complete=customlist,SessionComplete Rms :call delete(<f-args>)

