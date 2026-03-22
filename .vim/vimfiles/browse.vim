" Browse the web.

let s:sites = {
\   "google": "https://www.google.com/search?q=",
\   "python": "https://docs.python.org/3/search.html?q=",
\   "mdn": "https://developer.mozilla.org/en-US/search?q=",
\   "wikipedia": "https://en.wikipedia.org/w/index.php?search=",
\   "cisco": "https://search.cisco.com/search?query=",
\   "arista": "https://arista.my.site.com/AristaCommunity/s/global-search/%2540uri#q=",
\   "hpe": "https://support.hpe.com/connect/s/search?#q=",
\   "stackoverflow": "https://stackoverflow.com/search?q=",
\   "githubrepos": "https://github.com/search?type=repositories&q=",
\   "ruby": "https://www.google.com/search?q=site:docs.ruby-lang.org ",
\   "make": "https://www.google.com/search?q=site:gnu.org/software/make/manual/html_node ",
\   "guile": "https://www.google.com/search?q=site:gnu.org/software/guile/manual/html_node ",
\   "bash": "https://www.google.com/search?q=site:gnu.org/software/bash/manual/html_node ",
\   "man": "https://www.google.com/search?q=site:man7.org/linux/man-pages ",
\}

let s:site_names = keys(s:sites)

" Autocomplete site names.
func! s:BrowseComplete(A, L, P)
    " Don't autocomplete anything other than the site name.
    if a:L =~# 'Browse \w\+ '
        return []
    endif
    return filter(copy(s:site_names), "v:val =~ '" . a:A . "'")
endfunc

" Launches the user's query in the default web browser.
func! s:Browse(site, ...)
    if !has_key(s:sites, a:site)
        return
    endif

    " Let the user type spaces without needing to escape by combining all other arguments into a
    " single query string.
    let url = s:sites[a:site]
    let query = join(a:000, " ")

    if has("win32")
        call system("explorer \"`\"" . url . query . "\"`\"")
    else
        call job_start("xdg-open \"" . url . query . "\"")
    endif
endfunc

command! -nargs=+ -complete=customlist,s:BrowseComplete Browse :call s:Browse(<f-args>)
nnoremap <Leader>b :Browse <Tab>

