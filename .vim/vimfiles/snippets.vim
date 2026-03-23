" Custom snippets.

" Helper function that inserts the given list of strings into the current buffer at the current
" line. Automatically handles indendation and terminal buffers.
func! s:Insert(lines)
    " Edge case for terminal buffers.
    if &buftype == "terminal"
        call feedkeys(join(a:lines, " "))
        return
    endif
    
    " How we indent should respect the expandtab setting for the current buffer.
    if &expandtab
        let indent = repeat(" ", indent("."))
    else
        let indent = repeat("\t", indent("."))
    endif

    " Add indents to each line.
    call map(a:lines, "indent . v:val")

    call append(line(".") - 1, a:lines)
endfunc

" --- HTML Snippets ---

" Inserts HTML file boilerplate.
func! Snippethtmlnewfile(...)
    call s:Insert([
        \"<html>",
        \"    <head>",
        \"    </head>",
        \"    <body>",
        \"    </body>",
        \"</html>",
    \])

    norm gg
endfunc

func! Snippethtmlselectoption(...)
    call s:Insert([
        \"<select id=\"\">",
        \"    <option value=\"option1\">Option 1</option>",
        \"    <option value=\"option2\">Option 2</option>",
        \"</select>",
    \])

    norm 4k2f"
    startinsert
endfunc

" Inserts a link tag to pull in external CSS.
func! Snippethtmllinkcss(...)
    call s:Insert([
        \"<link rel=\"stylesheet\" href=\"\"/>",
    \])

    norm k_4f"
    startinsert
endfunc

" Inserts a script tag to pull in external JavaScript.
func! Snippethtmlscript(...)
    call s:Insert([
        \"<script src=\"\"></script>",
    \])

    norm k_2f"
    startinsert
endfunc

" Inserts a boilerplate HTML table.
func! Snippethtmltable(...)
    call s:Insert([
        \"<table>",
        \"    <thead>",
        \"        <tr>",
        \"            <th>header</th>",
        \"        </tr>",
        \"    </thead>",
        \"    <tbody>",
        \"        <tr>",
        \"            <td>value</td>",
        \"        </tr>",
        \"    </tbody>",
        \"</table>",
    \])

    " Drop user in insert mode in the first header tag.
    norm 9kdit
    startinsert
endfunc

" --- JavaScript Snippets ---

" Fetch API boilerplate.
func! Snippetjavascriptfetch(...)
    call s:Insert([
        \"const res = await fetch();",
        \"",
        \"if (!res.ok) {",
        \"    /* handle not ok */",
        \"}",
        \"",
        \"const body = await res.json();",
    \])

    norm 7kf)
    startinsert
endfunc

" Fetch API boilerplate for POST requests.
func! Snippetjavascriptfetchpost(...)
    call s:Insert([
        \"const res = await fetch(, {",
        \"    method: \"POST\",",
        \"    body: JSON.stringify({})",
        \"});",
        \"",
        \"if (!res.ok) {",
        \"    /* handle not ok */",
        \"}",
        \"",
        \"const body = await res.json();",
    \])

    norm 10kf,
    startinsert
endfunc

" JavaScript function. Optional accepts a function name.
func! Snippetjavascriptfunction(...)
    if a:0 > 0
        let function_name = a:1
    else
        let function_name = ""
    endif

    call s:Insert([
        \"function " . function_name . "() {",
        \"}",
    \])

    if function_name == ""
        norm 2kf(
        startinsert
    else
        execute "norm kO\<Tab>"
        startinsert!
    endif
endfunc


" -- Bash/Shell Snippets ---

" Drops an if condition for a file existing.
func! Snippetshfileexists(...)
    call s:Insert([
        \"if [ -f \"\" ]; then",
        \"    # handle file existing",
        \"fi",
    \])

    norm 3k2f"
    startinsert
endfunc

" Drops an if condition for a file not existing.
func! Snippetshfilenotexists(...)
    call s:Insert([
        \"if [ ! -f \"\" ]; then",
        \"    # handle file not existing",
        \"fi",
    \])

    norm 3k2f"
    startinsert
endfunc

" Drops an if condition for a directory existing.
func! Snippetshdirectoryexists(...)
    call s:Insert([
        \"if [ -d \"\" ]; then",
        \"    # handle directory existing",
        \"fi",
    \])

    norm 3k2f"
    startinsert
endfunc

" Drops and if condition for a directory not existing.
func! Snippetshdirectorynotexists(...)
    call s:Insert([
        \"if [ ! -d \"\" ]; then",
        \"    # handle directory not existing",
        \"fi",
    \])

    norm 3k2f"
    startinsert
endfunc

" Bash function. Optionally accepts a function name.
func! Snippetshfunction(...)
    if a:0 > 0
        let function_name = a:1
    else
        let function_name = ""
    endif

    call s:Insert([
        \"function " . function_name . "() {",
        \"}",
    \])

    if function_name == ""
        norm 2kf(
        startinsert
    else
        execute "norm kO\<Tab>"
        startinsert!
    endif
endfunc

" --- Python Snippets ---

" Python function. Optionally accepts a function name.
func! Snippetpythonfunction(...)
    if a:0 > 0
        let function_name = a:1
    else
        let function_name = ""
    endif

    call s:Insert([
        \"def " . function_name . "():",
    \])

    if function_name == ""
        norm kf(
        startinsert
    else
        execute "norm O\<Tab>"
        startinsert!
    endif
endfunc

" Flask boilerplate.
func! Snippetpythonflask(...)
    call s:Insert([
        \"from flask import Flask",
        \"",
        \"app = Flask(__name__)",
        \"",
        \"@app.route(\"/\")",
        \"def index():",
        \"    return {}",
        \"",
        \"if __name__ == \"__main__\":",
        \"    app.run(host=\"0.0.0.0\", port=5000)",
    \])

    norm gg
endfunc

" Creates a Python class. Optionally accepts a class name. If one is not provided, the cursor is
" automatically positioned in insert mode where the class name should be.
func! Snippetpythonclass(...)
    if a:0 > 0
        let class_name = a:1
    else
        let class_name = ""
    endif

    call s:Insert([
        \"class " . class_name . ":",
        \"    \"\"\"",
        \"    \"\"\"",
        \"",
        \"    def __init__(self):",
        \"        \"\"\"",
        \"        \"\"\"",
    \])

    " Let user type class name if not provided in snippet arguments.
    if class_name == ""
        norm 7kw
        startinsert
    endif
endfunc

" Create a Python main block.
func! Snippetpythonmain(...)
    call s:Insert([
        \"if __name__ == \"__main__\":",
        \"    ",
    \])

    norm k
    startinsert!
endfunc

" --- Terminal Snippets ---

" Sources a Python venv.
func! Snippetterminalvenv(...)
    if has("win32")
        call s:Insert(["venv\\Scripts\\activate"])
    else
        call s:Insert([". venv/bin/activate"])
    endif
endfunc

" --- Vimscript Snippets ---

" Creates a custom command.
func! Snippetvimcommand(...)
    call s:Insert([
        \"command! -nargs=n -complete=customlist,CompleteFunction CommandName :call CommandFunction(<f-args>)",
    \])
endfunc

" Vimscript function. Optionally accepts a function name.
func! Snippetvimfunction(...)
    if a:0 > 0
        let function_name = a:1
    else
        let function_name = ""
    endif

    call s:Insert([
        \"func! " . function_name . "()",
        \"endfunc",
    \])

    if function_name == ""
        norm 2kf(
        startinsert
    else
        execute "norm kO\<Tab>"
        startinsert!
    endif
endfunc

" Creates a custom snippet function.
func! Snippetvimsnippet(...)
    call s:Insert([
        \'" Header comment.',
        \"func! Snippetlangname(...)",
        \"    call s:Insert([",
        \"        \\\"\"",
        \"    \\])",
        \"endfunc",
    \])
endfunc

" Completion function for Snippet command.
func! s:SnippetComplete(A, L, P)
    " Don't autocomplete anything other than the snippet name.
    if a:L =~# 'Snippet \w\+ '
        return []
    endif

    if &buftype == "terminal"
        let lang = "terminal"
    else
        let lang = &syntax 
    endif

    if lang == ""
        return []
    endif

    let snippet_functions = getcompletion("Snippet" . lang . a:A . "*", "function")

    " Remove the prefix to isolate the snippet name. getcompletion also includes the open parens,
    " so chop off the last character to remove it.
    return map(snippet_functions, "substitute(v:val, 'Snippet" . lang . "', '', 'g')[:-2]")
endfunc

" Main executor for the snippet plugin. Handles turning the snippet name into a callable function
" and calls it.
func! s:Snippet(snippet_name, ...)
    if trim(a:snippet_name) == ""
        return
    endif

    if &buftype == "terminal"
        let lang = "terminal"
    else
        let lang = &syntax 
    endif

    call call("Snippet" . lang . a:snippet_name, a:000)
endfunc

command! -nargs=+ -complete=customlist,s:SnippetComplete Snippet :call s:Snippet(<f-args>)

" Keyboard shortcuts for the snippet command.
nnoremap <Leader>s :Snippet <Tab>

