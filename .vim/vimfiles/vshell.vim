" Eshell-style REPL for vimscript.
func! VshellImpl()
    " Evaluates a single line of input.
    func! VshellEval(text)
        let trimmed_text = trim(a:text)
        if trimmed_text == ""
            return
        endif

        let split_input = filter(split(trimmed_text, " "), 'v:val != ""')
        let cmd = split_input[0]
        let args = split_input[1:]
        let joined_args = join(args, " ")
        let line_num = line(".") - 1

        " Handle individual commands. Anything not known is passed to the default shell.
        if cmd == "clear" || cmd == "cls"
            %d
            return
        elseif cmd == "h" || cmd == "help"
            execute("vert help " . joined_args)
            return
        elseif cmd == "ls"
            let files = globpath(".", "*", 0, 1) + globpath(".", ".*", 0, 1)

            " Remove leading ./ from list.
            let files = map(files, 'substitute(v:val, "./", "", "g")')

            " Remove special "." and ".." paths.
            let files = filter(files, 'v:val != "." && v:val != ".."')
            call append(line_num, join(files, " "))
            return
        elseif cmd == "vi" || cmd == "vim"
            execute("next! " . joined_args)
            return
        elseif cmd == "cd"
            execute("cd " . joined_args)
            return
        elseif cmd == "exit" || cmd == "q" || cmd == "quit"
            q!
            return
        endif

        " Pass anything else to system.
        try
            call append(line_num, split(trim(system(a:text)), "\n"))
        catch
            call append(line_num, split(trim(v:exception), "\n"))
        endtry
    endfunc
    
    " Helper function to set the prompt buffer prompt.
    func! VshellSetPrompt()
        " Replace home path with "~".
        let home_dir = expand("~")
        let prompt_path = substitute(getcwd(), home_dir, "~", "g")
        call prompt_setprompt(bufnr(), prompt_path . "% ")
    endfunc

    " Set up new buffer for shell.
    enew
    setlocal buftype=prompt bufhidden=delete wrap nonumber norelativenumber

    " QuitPre covers quitting in the vshell buffer and BufLeave handles leaving the buffer first
    " and quitting from another buffer.
    au QuitPre,BufLeave,ModeChanged <buffer> setlocal nomodified

    " Update the prompt when directory changes.
    au DirChanged <buffer> call VshellSetPrompt()
    call VshellSetPrompt()

    call prompt_setcallback(bufnr(), function("VshellEval"))

    file vshell

    " Tab completion for paths.
    inoremap <buffer> <Tab> <C-x><C-f>
    startinsert
endfunc
command! Vshell call VshellImpl()

