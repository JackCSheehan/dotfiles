" Eshell-style REPL for vimscript.
func! VshellImpl()
    " Evaluates a single line of input.
    func! VshellEval(text)
        let lower_text = trim(tolower(a:text))

        " Handle clearing the window.
        if lower_text == "clear" || lower_text == "cls"
            :%d
            return
        elseif lower_text == "exit"
            :q!
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
    setlocal buftype=prompt
    setlocal nonumber norelativenumber nomodified
    call prompt_setcallback(bufnr(), function("VshellEval"))
    file vshell

    " Tab completion for vimscript functions.
    inoremap <buffer> <Tab> <C-x><C-v>
    startinsert
endfunc
command! Vshell call VshellImpl()

