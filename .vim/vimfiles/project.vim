" Project management in Vim.
let g:projects_dir = expand("~/.vim/projects/")
let g:project_name = ""

call mkdir(g:projects_dir, "p")

if has("win32")
    let g:path_separator = "\\"
else
    let g:path_separator = "\/"
endif

" Helper function to sanitize a raw project name input.
func! s:fixProjectName(raw_project_name) abort
    return tolower(substitute(a:raw_project_name, " ", "_", "g"))
endfunc

" If we're currently in a loaded project, save it on exit.
func! ProjectExitCallback() abort
    if g:project_name != ""
        call ProjectSave()
    endif
endfunc
au VimLeavePre * call ProjectExitCallback()

" List all saved projects.
func! ProjectList() abort
    let projects = globpath(g:projects_dir, "*/", 0, 1)
    if len(projects) == 0
        echo "No projects."
        return
    endif
    for project in projects
        echo split(project, g:path_separator)[-1]
    endfor
endfunc
nnoremap <C-p>l :call ProjectList()<Return>
tnoremap <C-p>l <C-w>:call ProjectList()<Return>

" Helper function to handle unloading the current project.
func! s:projectUnload() abort
    let g:project_name = ""

    " Clear out current buffers.
    try
        bufdo bd
    catch
        echoerr v:exception
        return
    endtry

    " Start with a fresh buffer.
    enew
endfunc

" Opens a project by sourcing the session and cleaning up buffers.
func! ProjectOpen() abort
    " If we're opening from an existing project, save it first.
    if g:project_name != ""
        call ProjectSave()
    endif
    
    call ProjectList()
    let project_name = s:fixProjectName(input("Open project: "))
    if project_name == ""
        return
    endif

    " Unload the current project.
    call s:projectUnload()

    let g:project_name = project_name
    let session_dir = g:projects_dir . project_name

    execute("source " . session_dir . "/session.vim")
    let &tags = session_dir . "/tags"
endfunc
nnoremap <C-p>o :call ProjectOpen()<Return>
tnoremap <C-p>o <C-w>:call ProjectOpen()<Return>

" Deletes a project.
func! ProjectDelete() abort
    call ProjectList()
    let project_name = s:fixProjectName(input("Delete project: "))
    if project_name == ""
        return
    endif

    call delete(g:projects_dir . project_name, "rf")

    " If we just deleted the current project, reset the variable.
    if g:project_name == project_name
        let g:project_name = ""
    endif
endfunc
nnoremap <C-p>d :call ProjectDelete()<Return>
tnoremap <C-p>d <C-w>:call ProjectDelete()<Return>

" Creates a new project directory and writes a vim session to disk.
func! ProjectSave() abort
    " If we already have a project, just save over the current session.
    if g:project_name != ""
        execute("mksession! " . v:this_session)
    else
        let project_name = s:fixProjectName(input("New project: "))
        let g:project_name = project_name

        call mkdir(g:projects_dir . project_name, "p")
        execute("mksession! " . g:projects_dir . g:project_name . "/session.vim")
    endif
endfunc
nnoremap <C-p>s :call ProjectSave()<Return>
tnoremap <C-p>s <C-w>:call ProjectSave()<Return>

" Like project save, but always creates a new project.
func! ProjectNew() abort
    " If we have a project already, save it.
    if g:project_name != ""
        call ProjectSave()
    endif

    " Clear and create a new project.
    call s:projectUnload()
    call ProjectSave()
endfunc
nnoremap <C-p>n :call ProjectNew()<Return>
tnoremap <C-p>n <C-w>:call ProjectNew()<Return>

