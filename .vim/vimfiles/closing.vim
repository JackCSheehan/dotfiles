" Code to handle automatically closing container characters such as parenthesis and quotes.



" Special handler for auto-closing characters that have the same opening character and closing
" character, such as double and single quotes.
func! HandleMatchingQuotes(char)
    let syntax_id = synIDattr(synID(line("."), col(".") - 1, 1), "name") 

    " Do not quote expand in certain places in Vim files since double quotes are used as comments.
    if &syntax == "vim" && (syntax_id == "" || syntax_id == "vimFunctionBody")
        return a:char
    endif
    
    " Do not do quote expansion in comments. This is to prevent auto-matching single quotes where we
    " mean to use them as apostrophes. We'll also exclude matching in Python strings since
    " docstrings are often used as comment equivalents for documenting code.
    if syntax_id =~? "comment" || syntax_id == "pythonString"
        return a:char
    endif

    let current_char = getline(".")[col(".") - 1]
    let prev_char = getline(".")[col(".") - 2]
    let prev_prev_char = getline(".")[col(".") - 3]
    
    " Allow us to be able to do type three quotes in a row by not trying to auto-close in the
    " event that we already have two characters in a row.
    if prev_prev_char == a:char && prev_char == a:char
        return a:char
    endif

    " If the current char is the closing char, don't re-type it.
    if prev_char == a:char && current_char == a:char
        " Advance the cursor to not break typing flow.
        return "\<Right>"
    endif

    " Otherwise, automatically close the opening character.
    return a:char . a:char . "\<Left>"
endfunc

" Helper function to handle conditionally not typing a closing character when not needed.
func! HandleClosingChar(opening_char, closing_char)
    let current_char = getline(".")[col(".") - 1]
    let prev_char = getline(".")[col(".") - 2]

    " Don't let the user re-type the automatically-closed closing char.
    if prev_char == a:opening_char && current_char == a:closing_char
        " Advance the cursor to not break typing flow.
        return "\<Right>"
    endif

    " Otherwise, just close the character.
    return a:closing_char
endfunc

" Automatic parenthesis / brace matching.
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap < <><Left>

" Handle edge cases for auto-closing characters.
inoremap <expr> <silent> ) HandleClosingChar("(", ")")
inoremap <expr> <silent> } HandleClosingChar("{", "}")
inoremap <expr> <silent> ] HandleClosingChar("[", "]")
inoremap <expr> <silent> > HandleClosingChar("<", ">")

" Quotes need special logic for auto matching.
inoremap <expr> " HandleMatchingQuotes("\"")
inoremap <expr> ' HandleMatchingQuotes("\'")

