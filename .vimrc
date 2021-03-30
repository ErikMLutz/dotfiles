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
set smartindent            " smarter autoindent based on syntax
set clipboard=unnamedplus  " copy to system clipboard
let mapleader = ","        " use comma as leader key

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
  execute 'source' globpath(&rtp, 'autoload/lightline/colorscheme/ddev.vim')
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
set background = "dark"  " dark mode
set termguicolors        " use 24 bit colors
syntax enable            " enable syntax highlighting

augroup CustomColors  " set background when tmux focus changes
  autocmd!
  autocmd FocusGained * execute expand("highlight Normal guibg=$BACKGROUND_COLOR")
  autocmd FocusLost * execute expand("highlight Normal guibg=$COLOR_19")
augroup END
colorscheme base16-$PROFILE_NAME  " sync colorscheme with DDev theme

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
