" Eshell-style REPL for vimscript.

func! VshellImpl() abort
    let vshell_command_history = []
    let vshell_command_index = 0

    " Evaluates a single line of input.
    func! VshellEval(text) closure
        let trimmed_text = trim(a:text)
        if trimmed_text == ""
            return
        endif

        call add(vshell_command_history, trimmed_text)
        let vshell_command_index = len(vshell_command_history) - 1

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
            execute("lcd " . joined_args)
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
        call prompt_setprompt(bufnr(), "\e[32m" . prompt_path . "\e[m\e[36m ʌ\e[m ")
    endfunc

    " Set up new buffer for shell.
    enew
    file vshell
    setlocal buftype=prompt bufhidden=delete wrap nonumber norelativenumber noswapfile

    " QuitPre covers quitting in the vshell buffer and BufLeave handles leaving the buffer first
    " and quitting from another buffer.
    au QuitPre,BufLeave,ModeChanged <buffer> setlocal nomodified

    " ANSI colors.
    highlight AnsiRed guifg=red ctermfg=red
    highlight AnsiGreen guifg=green ctermfg=green
    highlight AnsiCyan guifg=cyan ctermfg=cyan
    highlight AnsiBold gui=bold cterm=bold

    " Handle ANSI codes.
    syntax region AnsiRed matchgroup=Conceal start='\e\[31m' end='\e\[[0]*m' concealends
    syntax region AnsiGreen matchgroup=Conceal start='\e\[32m' end='\e\[[0]*m' concealends
    syntax region AnsiCyan matchgroup=Conceal start='\e\[36m' end='\e\[[0]*m' concealends
    syntax region AnsiBold matchgroup=Conceal start='\e\[1m' end='\e\[[0]*m' concealends

    " Any remaining reset codes need to be concealed.
    syntax match Conceal /\e\[[0]*m/ conceal

    " Update the prompt when directory changes.
    au DirChanged <buffer> call VshellSetPrompt()
    call VshellSetPrompt()

    call prompt_setcallback(bufnr(), function("VshellEval"))

    " Tab completion for paths.
    inoremap <buffer> <Tab> <C-x><C-f>
    
    " Helper function to clear the current line.
    func! ClearLine()
        norm dd
        startinsert
    endfunc

    " Helper function to handle command pulling commands from the command history.
    func! ComputeCommandHistory(inc) closure
        if len(vshell_command_history) == 0
            return ""
        endif

        call ClearLine()

        let command = vshell_command_history[vshell_command_index]
        let vshell_command_index += a:inc

        " Prevent exceeding bounds.
        if vshell_command_index < 0
            let vshell_command_index = 0
        elseif vshell_command_index >= len(vshell_command_history)
            let vshell_command_index = len(vshell_command_history) - 1
        endif

        return command
    endfunc

    " Command history.
    inoremap <buffer> <silent> <C-p> <C-r>=ComputeCommandHistory(-1)<Return>
    inoremap <buffer> <silent> <C-n> <C-r>=ComputeCommandHistory(1)<Return>

    " Ctrl-L to clear screen.
    inoremap <buffer> <silent> <C-l> <Esc>:%d<Cr>i

    " GNU readline shortcuts.
    inoremap <buffer> <silent> <C-a> <Home>
    inoremap <buffer> <silent> <C-e> <End>
    inoremap <buffer> <silent> <C-f> <Right>
    inoremap <buffer> <silent> <C-b> <Left>
    inoremap <buffer> <silent> <C-d> <Delete>
    inoremap <buffer> <silent> <M-f> <S-Right>
    inoremap <buffer> <silent> <M-b> <S-Left>

    " Many terminal emulators will clear out the current line on Ctrl-C, so match that behavior.
    inoremap <buffer> <C-c> <Nop>
    inoremap <buffer> <silent> <C-c> <C-o>:call ClearLine()<Return>

    startinsert
endfunc

command! Vshell call VshellImpl()

