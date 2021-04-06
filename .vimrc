" VIM Configuration

" General
set mouse=a                " allow mouse controls for all modes
set backspace=2            " allow backspacing over end of lines
set number                 " show line numbers
set ignorecase             " case insensitive searches
set smartcase              " case sensitive if upper case letters are included
set lazyredraw             " redraw the screen less
set splitbelow             " create horizontal splits below current window
set splitright             " create vertical splits to the right of current window
set undofile               " save undo history to file and persist across sessions
set undodir=~/.vim/undo    " location of undo history file
set viewdir=~/.vim/view    " location of saved views
set smartindent            " smarter autoindent based on syntax
set clipboard=unnamedplus  " copy to system clipboard
let mapleader = ','        " use comma as leader key

" Install Plugins
if empty(glob('~/.vim/autoload/plug.vim'))  " auto install vim-plug
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'             " library of colorschemes that match DDev shell themes
Plug 'itchyny/lightline.vim'               " lightweight Powerline for Vim
Plug 'tpope/vim-fugitive'                  " Git integration
Plug 'tpope/vim-eunuch'                    " common Unix commands
Plug 'tpope/vim-surround'                  " interact with 'surroundings' like quotes or parentheses
Plug 'tpope/vim-abolish'                   " better abbreviation and substitution
Plug 'tpope/vim-sleuth'                    " automatically detect and set expandtab and shiftwidth
Plug 'tpope/vim-repeat'                    " add repeat (.) compatibility for many plugins
Plug 'junegunn/fzf'                        " fzf base functionality
Plug 'junegunn/fzf.vim'                    " additional fzf integrations with vim
Plug 'junegunn/goyo.vim'                   " distraction free mode
Plug 'junegunn/limelight.vim'              " hyperfocus text under cursor
Plug 'preservim/nerdtree'                  " file browser
Plug 'preservim/nerdcommenter'             " quick comment commands
Plug 'tmux-plugins/vim-tmux-focus-events'  " hook tmux focus events into FocusGained and FocusLost

call plug#end()

" itchyny/lightline.vim
set noshowmode  " disable default mode label since lightline has it's own
function! LightlineFullPath()  " full file path with trunctation logic
  return winwidth(0) > 70 ? expand('%') : ''
endfunction

let g:lightline = {
  \  'colorscheme': 'ddev',
  \   'active': {
  \     'left': [['mode', 'paste' ], ['filename', 'modified'], ['git']],
  \     'right': [['lineinfo'], ['percent'], ['filepath']]
  \   },
  \   'component_function': {
  \     'git': 'fugitive#head',
  \     'filepath': 'LightlineFullPath',
  \   },
  \   'separator': { 'left': '', 'right': '' },
  \   'subseparator': { 'left': '', 'right': '' },
  \ }

command! LightlineReload call LightlineReload()  " Reload lightline, for use with ddev sync
function! LightlineReload()
  execute 'source' globpath(&rtp, 'autoload/lightline/colorscheme/'. g:lightline.colorscheme. '.vim')
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" junegunn/fzf.vim
let g:fzf_files_options = ' --tiebreak end --preview "bat --color always {}"'  " use bat with colors for preview
command! -bang -nargs=* Rg
  \  call fzf#vim#grep(
  \    'rg --column --line-number --no-heading --color=always --smart-case --hidden '.shellescape(<q-args>),
  \    1,
  \    fzf#vim#with_preview({'options': ['--tiebreak=end']}), <bang>0)  " modify Rg command to include preview

map ; :Files<CR>|       " use fzf to search file list, mirrors DDev's "f nvim" command
map <leader>; :Rg<CR>|  " use fzf to search within files, mirrors DDev's "f" command

" junegunn/goyo.vim
autocmd! User GoyoEnter Limelight  " sync Limelight with Goyo
autocmd! User GoyoLeave Limelight!

" preservim/nerdtree
let g:NERDTreeShowHidden = 1               " show hidden files
let g:NERDTreeIgnore=['\.git$']            " hide .git directories
nnoremap <leader>o :NERDTreeToggle<CR>|    " toggle NERDTree sidebar

" preservim/nerdcommenter
let g:NERDSpaceDelims = 1             " add space after comment delimiter
let g:NERDDefaultAlign = 'left'       " align multi-line comment delimiters instead of following code indentation
let g:NERDCommentEmptyLines = 1       " also comment empty lines
let g:NERDTrimTrailingWhitespace = 1  " auto trim trailing whitespace on uncomment

" Color Scheme
set background=dark      " dark mode
set termguicolors        " use 24 bit colors
syntax enable            " enable syntax highlighting

function! FocusBackground()  " set normal background colors
  let l:guibg = expand("$BACKGROUND_COLOR")
  execute "highlight Normal guibg=". l:guibg
  execute "highlight VertSplit guibg=". l:guibg
  execute "highlight StatusLine guibg=". l:guibg
  execute "highlight StatusLineNC guibg=". l:guibg
  execute "highlight NonText guibg=". l:guibg
  unlet l:guibg
  if &laststatus == 2  " don't reload lighline if it's not visible
    let g:lightline.colorscheme = 'ddev'
    call LightlineReload()
  endif
endfunction

function! UnfocusBackground()  " set a lighter background color
  let l:guibg = expand("$COLOR_19")
  execute "highlight Normal guibg=". l:guibg
  execute "highlight VertSplit guibg=". l:guibg
  execute "highlight StatusLine guibg=". l:guibg
  execute "highlight StatusLineNC guibg=". l:guibg
  execute "highlight NonText guibg=". l:guibg
  unlet l:guibg
  if &laststatus == 2  " don't reload lighline if it's not visible
    let g:lightline.colorscheme = 'ddev_unfocused'
    call LightlineReload()
  endif
endfunction

augroup CustomColors  " set background when tmux focus changes
  autocmd!
  autocmd FocusGained * call FocusBackground()
  autocmd FocusLost * call UnfocusBackground()
augroup END
colorscheme base16-$PROFILE_NAME  " sync colorscheme with DDev theme

" Journaling
let g:journal_file = '~/.journal.md'
function! ToggleJournal()  " quickly jump to and from journal
  if expand('%:p') != expand(g:journal_file)  " open journal and set theme
    let g:journal_last_tab = tabpagenr()
    tabnew
    execute 'edit' g:journal_file
    silent! loadview  " load stored view so we always return to the same place
    Goyo120
  else
    mkview  " store our view of the file so it can be restored
    quit  " quit Goyo mode
    silent write
    quit  " quit original tab
    execute 'tabnext ' . g:journal_last_tab
  endif
endfunction

nnoremap <silent> <leader>j :call ToggleJournal()<CR>|  " open and close journal

" Session Management

function! MakeSession()  " explicitly write a session
  let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
  if (filewritable(b:sessiondir) != 2)
    execute 'silent !mkdir -p ' . b:sessiondir
    redraw!
  endif
  let b:sessionfile = b:sessiondir . '/session.vim'
  execute 'mksession! ' . b:sessionfile
endfunction

function! DeleteSession()  " explicitly delete a session
  let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
  let b:sessionfile = b:sessiondir . '/session.vim'
  if (filereadable(b:sessionfile))
    execute 'silent !rm ' . b:sessionfile
  endif
endfunction

function! UpdateSession()  " update a session, only if it exists
  if argc() == 0  " don't save if nvim is called on a specific file
    let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
    let b:sessionfile = b:sessiondir . '/session.vim'
    if (filereadable(b:sessionfile))
      execute 'mksession! ' . b:sessionfile
    endif
  endif
endfunction

function! LoadSession()  " load a session, only if it exists
  if argc() == 0  " don't load if nvim is called on a specific file
    let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
    let b:sessionfile = b:sessiondir . '/session.vim'
    if (filereadable(b:sessionfile))
      execute 'source ' b:sessionfile
    endif
  else
    let b:sessionfile = ''
    let b:sessiondir = ''
  endif
endfunction

autocmd VimEnter * nested :call LoadSession()
autocmd VimLeave * :call UpdateSession()
nnoremap <leader>m :call MakeSession()<CR>
nnoremap <leader>M :call DeleteSession()<CR>

" Markdown
let g:markdown_fenced_languages = ['sh', 'python']
let g:markdown_checkbox_states = [ ' ', 'X']

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

function! MarkdownFoldLevel()
    let line = getline(v:lnum)

    if line =~ '^#\+ .*$'  " define fold level by header level
      return ">" . strlen(matchstr(line, '^#\+'))
    endif

    if line =~ '^\s*```\w\+.*$'  " increase fold level at start of code blocks
      return "a1"
    endif

    if line =~ '^\s*```$'  " decrease fold level at end of code blocks
      return "s1"
    endif

    return "="  " use fold level of previous line by default
endfunction

augroup markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=120
  autocmd FileType markdown setlocal foldmethod=expr
  autocmd FileType markdown setlocal foldexpr=MarkdownFoldLevel()
  autocmd FileType markdown nnoremap <silent> - :call ToggleCheckbox()<CR>
  autocmd FileType markdown nnoremap <silent> _ :keeppatterns call search('\[ \]')<CR>  " go to next incomplete task
augroup END

" Key Bindings
nnoremap <silent> <leader>t :tabnew<CR>|  " new tab
nnoremap <silent> <tab> gt|               " next tab
nnoremap <silent> <s-tab> gT|             " previous tab

nnoremap <C-j> <C-W><C-J>|  " go to split below
nnoremap <C-k> <C-W><C-K>|  " go to split above
nnoremap <C-l> <C-W><C-L>|  " go to split to the right
nnoremap <C-h> <C-W><C-H>|  " go to split to the left

nnoremap ˚ :m -2<CR>|  " move current line up
nnoremap ∆ :m +1<CR>|  " move current line down

nnoremap j gj|  " move up by visual line instead of literal line (i.e. wrapped lines)
nnoremap k gk|  " move down by visual line instead of literal line (i.e. wrapped lines)

nnoremap B ^|  " move to beginning of line
nnoremap E $|  " move to end of line

nnoremap <leader>y :%y<CR>|  " copy entire buffer

nnoremap <space> za|  " toggle fold

nnoremap <silent> <leader><space> :nohlsearch<CR>|  " remove search highlighting
