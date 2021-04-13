" Golang Filetype Settings
setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal foldmethod=syntax

" vim-go general settings
let g:go_auto_type_info = 1            " automatically show GoInfo for the item under the cursor
let g:go_updatetime = 250              " run auto type info calls after 250 ms, instead of default 800 ms

" vim-go highlighting settings
let g:go_highlight_function_calls = 1  " e.g. pkg.subpkg.*Function*(...)
let g:go_highlight_fields = 1          " e.g. pkg.*Field*

" N.B. (April 13th, 2021) without this line `gopls` seems to work terribly! Some functions work, like autoformatting,
" but can take 10-30 seconds to run.  Some functions, like getting documentation, don't work at all. Adding this line in
" makes everything run snappily and without errors.
let g:go_gopls_options=[]
