" Eshell-style REPL for vimscript.
func! VshellImpl()
    " Evaluates a single line of input.
    func! VshellEval(text)
        let trimmed_text = trim(a:text)

        " Handle clearing the window.
        if trimmed_text == "clear" || trimmed_text == "cls"
            %d
            return
        elseif stridx(trimmed_text, "h ") == 0 || stridx(trimmed_text, "help ") == 0
            let search_term = join(split(trimmed_text, " ")[1:], "")
            execute("vert help " . search_term)
            return
        elseif trimmed_text == "exit"
            q!
            return
        endif

        " Pass anything else to execute.
        let line_num = line(".") - 1
        try
            call append(line_num, split(trim(execute(a:text)), "\n"))
        catch
            call append(line_num, split(trim(v:exception), "\n"))
        endtry
    endfunc!

    " Set up new buffer for shell.
    enew
    setlocal buftype=prompt bufhidden=delete nonumber norelativenumber

    " QuitPre covers quitting in the vshell buffer and BufLeave handles leaving the buffer first
    " and quitting from another buffer.
    au QuitPre,BufLeave,ModeChanged <buffer> setlocal nomodified

    call prompt_setcallback(bufnr(), function("VshellEval"))
    file vshell

    " Tab completion for vimscript functions.
    inoremap <buffer> <Tab> <C-x><C-v>
    startinsert
endfunc
command! Vshell call VshellImpl()

