" Tags implementation.

let g:vtags = {}

func! s:python(file) abort
    let line_num = 1
    let file_content = readfile(a:file)

    for line in file_content
        " Find functions.
        let m = matchstr(line, "def.*\(")
        if m != ""
            let func_name = trim(split(split(m, "(")[0], "def")[0])
            let g:vtags[func_name] = {"path": a:file, "line": line_num}
            continue
        endif

        " Find global assignments.
        let m = matchstr(line, '^[a-zA-Z_0-9]\+[ \t]*=')
        if m != ""
            let global_name = trim(split(m, "=")[0])
            let g:vtags[global_name] = {"path": a:file, "line": line_num}
            continue
        endif

        let line_num = line_num + 1
    endfor
endfunc

func! Vtags() abort
    let start = reltime()
    let path = getcwd()
   
    " Get files to check.
    let files = globpath(path, "**/*.py", 0, 1)

    for file in files
        call s:python(file)
    endfor
    echo "Completed in " . trim(reltimestr(reltime(start))) . " seconds"
endfunc

