" Project management in Vim.
let g:projects_dir = expand("~/.vim/projects/")
let g:project_name = ""

call mkdir(g:projects_dir, "p")

" Helper function to sanitize a raw project name input.
func! FixProjectName(raw_project_name)
    return tolower(substitute(a:raw_project_name, " ", "_", "g"))
endfunc

" If we're currently in a loaded project, save it on exit.
func! ProjectExitCallback()
    if g:project_name != ""
        call ProjectSave()
    endif
endfunc
au VimLeavePre * call ProjectExitCallback()

" List all saved projects.
func! ProjectList()
    let projects = globpath(g:projects_dir, "*/", 0, 1)
    if len(projects) == 0
        echo "No projects."
        return
    endif
    for project in projects
        echo split(project, "\/")[-1]
    endfor
endfunc
nnoremap <C-p>l :call ProjectList()<Return>
tnoremap <C-p>l <C-w>:call ProjectList()<Return>

" Opens a project by sourcing the session and cleaning up buffers.
func! ProjectOpen()
    " If we're opening from an existing project, save it first.
    if g:project_name != ""
        call ProjectSave()
    endif
    
    call ProjectList()
    let project_name = FixProjectName(input("Open project: "))
    if project_name == ""
        return
    endif

    let g:project_name = project_name

    " Clear out current buffers
    try
        bufdo bd
    catch
        echoerr v:exception
        return
    endtry
    enew

    let session_dir = g:projects_dir . project_name

    execute("source " . session_dir . "/session.vim")
    let &tags = session_dir . "/tags"
endfunc
nnoremap <C-p>o :call ProjectOpen()<Return>
tnoremap <C-p>o <C-w>:call ProjectOpen()<Return>

" Deletes a project.
func! ProjectDelete()
    call ProjectList()
    let project_name = FixProjectName(input("Delete project: "))
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
func! ProjectSave()
    " If we already have a project, just save over the current session.
    if g:project_name != ""
        execute("mksession! " . v:this_session)
    else
        let project_name = FixProjectName(input("New project: "))
        let g:project_name = project_name

        call mkdir(g:projects_dir . project_name, "p")
        execute("mksession! " . g:projects_dir . g:project_name . "/session.vim")
    endif
endfunc
nnoremap <C-p>s :call ProjectSave()<Return>
tnoremap <C-p>s <C-w>:call ProjectSave()<Return>

