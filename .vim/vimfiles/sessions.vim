" Session management.

" Ensure a session directory is always created.
let s:session_dir = expand("~/.vim/session/")
call mkdir(s:session_dir, "p")
let s:session_file = s:session_dir . "session.vim"

au VimLeave * call execute(":mksession! " . s:session_file)
call execute(":so " . s:session_file)
