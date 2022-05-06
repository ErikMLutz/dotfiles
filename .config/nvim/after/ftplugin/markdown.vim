" Markdown Filetype Settings
setlocal foldmethod=expr
setlocal foldexpr=MarkdownFoldLevel()

let g:markdown_fenced_languages = ['bash=sh', 'python', 'json', 'yaml']  " languages to highlight in fenced blocks
let g:markdown_checkbox_states = [ ' ', 'X']        " checkbox states in cycle order

" toggle '* [ ]' checkboxes between g:markdown_checkbox_states
function! ToggleCheckbox()  " inspired by 'jkramer/vim-checkbox'
  let line = getline('.')
  if match(line, '\[.\]') != -1
    let states = copy(g:markdown_checkbox_states)
    call add(states, states[0])  " for easy cycling

    for state in states
      if match(line, '\[' . state . '\]') != -1
        let next_state = states[index(states, state) + 1]
        let line = substitute(line, '\[' . state . '\]', '[' . next_state . ']', '')
        call setline('.', line)
        break
      endif
    endfor
  endif
endfunction

" custom folding for headers and code blocks
function! MarkdownFoldLevel()
    let line = getline(v:lnum)

    if line =~ '^#\+ .*$'  " define fold level by header level
      return ">" . strlen(matchstr(line, '^#\+'))
    endif

    if line =~ '^\s*```$'  " decrease fold level at end of code blocks
      return "s1"
    endif

    if line =~ '^\s*```\w*.*$'  " increase fold level at start of code blocks
      return "a1"
    endif

    return "="  " use fold level of previous line by default
endfunction

" mappings
nnoremap <buffer> <silent> - :call ToggleCheckbox()<CR>
nnoremap <buffer> <silent> _ :keeppatterns call search('\[ \]')<CR>  " go to next incomplete task
