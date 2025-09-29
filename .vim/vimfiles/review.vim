" Diff review for PR reviews. Call from command line directly with 'vim -c Review'
func! ReviewImpl()
    let current_branch = trim(system("git branch --show-current"))
    let default_remote_branch = trim(system("git symbolic-ref refs/remotes/origin/HEAD --short"))
    let git_diff_range = default_remote_branch . "..." . current_branch
    let patch = trim(system("git diff -W " . git_diff_range))

    " If no diff to show, do not proceed
    if len(patch) == 0
        return
    endif

    " Helper function which is called on all file name matches in a patch to add them to the
    " location list.
    func! PopulateLocList() closure
        let line_number = line(".")
        let line = getline(".")

        " Git marks the start of a file in a patch like so:
        " diff --git a/Makefile b/Makefile
        " Use regex to extract the file's name. We'll take the second file name in the line since that
        " will capture file renames.
        let file_name = matchlist(line, 'b/\(.*\)$')[1]

        " Append this file position to the location list.
        call setloclist(0, [], "a", {"items": [{"text": file_name, "bufnr": bufnr(""), "lnum": line_number}]})
    endfunc

    " Put the patch into the current buffer
    call setline(1, split(patch, "\n"))

    " Configure the diff buffer
    setlocal filetype=diff nomodifiable nomodified

    " Show diff summary info in the status line.
    let diff_shortstat = trim(system("git diff " . git_diff_range . " --shortstat"))
    call setbufvar("", "&statusline", "Diff for " . git_diff_range . " | " . diff_shortstat)

    " Use the global command to run PopulateLocList for every file found in the patch
    execute("g/^diff --git a/call PopulateLocList()")

    " Open location list and set a friendly statusline name title
    lopen 10
    call setbufvar("", "&statusline", "Modified files")
endfunc
command! Review call ReviewImpl()
