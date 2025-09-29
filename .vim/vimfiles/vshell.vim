" Eshell-style REPL for vimscript.
func! VshellImpl()
    " Evaluates a single line of input.
    func! VshellEval(text)
        let lower_text = tolower(a:text)

        " Handle clearing the window.
        if lower_text == "clear" || lower_text == "cls"
            :%d
            return
        endif

        " Pass anything else to execute.
        let line_num = line(".") - 1
        try
            call append(line_num, trim(execute(a:text)))
        catch
            call append(line_num, trim(v:exception))
        endtry
    endfunc!

    enew
    setlocal buftype=prompt
    setlocal nonumber norelativenumber nomodified
    call prompt_setcallback(bufnr(), function("VshellEval"))
    norm i
    file vshell
endfunc
command! Vshell call VshellImpl()

