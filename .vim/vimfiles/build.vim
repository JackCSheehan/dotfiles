" Build automation. Mimics Vim's :make command but uses jobs to not block the main thread.

" Function called when build is finished. Handles cleaning up and showing qf list.
func! BuildCallback(job, status)
    ccl
    call setqflist([])

    if a:status == 0
        try
            exe "bd buildout"
        catch
            " Edge case for if the buffer doesn't exist.
        endtry
        echo "Build completed succesfully"
        return
    endif

    cgete getbufline(bufnr("buildout"), 1, "$")
    copen
    let w:quickfix_title = "Build errors"
    exe "bd buildout"
endfunc

" Run the user's command in the background.
func! Build(cmd)
    call job_start(a:cmd, #{
    \ out_io: "buffer",
    \ err_io: "buffer",
    \ out_name: "buildout",
    \ err_name: "buildout",
    \ exit_cb: function("BuildCallback")
    \ })
    echo "Starting build"
endfunc

command! -nargs=1 -complete=shellcmdline Build :call Build(<q-args>)
nnoremap <Leader>b :Build 

set errorformat=
func! SetEfm(format)
    " These are boilerplate patterns we want everywhere.
    let make_format = 'make:\ ***\ [%f:%l:%.%#]\ %m'
    let grep_format = '%f:%l:\ %m'
    let ignore_format = '%-G%.%#'

    exe "set errorformat=" . a:format . "," . make_format . "," . grep_format . "," . ignore_format
endfunc

" g++/gcc.
autocmd BufEnter *.cpp,*.c,*.h,*.hpp call SetEfm('%f:%l:%c:\ %m')

" Go compiler.
autocmd BufEnter *.go call SetEfm('%\./%f:%l:%c:\ %m')

" Python. Stolen from :h errorformat.
autocmd BufEnter *.py call SetEfm('%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m')

