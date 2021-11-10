" VIM Configuration

" Filetype plugin files (<C-w>gf to open file under cursor in new tab)
" ~/.config/nvim/after/ftplugin/markdown.vim
" ~/.config/nvim/after/ftplugin/go.vim

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
set foldmethod=indent      " use indent folding by default
set foldlevelstart=99      " always open files unfolded by default
set textwidth=120          " wider files by default for better readability
set colorcolumn=121        " highlight edge of file
set completeopt+=menuone   " show menu even if there is only one match
set completeopt+=noinsert  " don't auto-insert matches, require user selection
set completeopt+=noselect  " don't auto-enter completion menu, require user interaction
set shortmess+=c           " disable extra completion messages
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
Plug 'tpope/vim-speeddating'               " increment and decrement support for datetimes
Plug 'tpope/vim-fugitive'                  " Git integration
Plug 'tpope/vim-surround'                  " interact with 'surroundings' like quotes or parentheses
Plug 'tpope/vim-abolish'                   " better abbreviation and substitution
Plug 'tpope/vim-eunuch'                    " common Unix commands
Plug 'tpope/vim-sleuth'                    " automatically detect and set expandtab and shiftwidth
Plug 'tpope/vim-repeat'                    " add repeat (.) compatibility for many plugins
Plug 'junegunn/fzf'                        " fzf base functionality
Plug 'junegunn/fzf.vim'                    " additional fzf integrations with vim
Plug 'junegunn/goyo.vim'                   " distraction free mode
Plug 'junegunn/limelight.vim'              " hyperfocus text under cursor
Plug 'preservim/nerdtree'                  " file browser
Plug 'preservim/nerdcommenter'             " quick comment commands
Plug 'tmux-plugins/vim-tmux-focus-events'  " hook tmux focus events into FocusGained and FocusLost
Plug 'neovim/nvim-lspconfig'               " configurations for built in language server client
Plug 'nvim-lua/completion-nvim'            " lightweight autocomplete based on language server
Plug 'pierreglaser/folding-nvim'           " cold folding based on language server
Plug 'nvim-treesitter/nvim-treesitter'     " generic syntax parsing, run :TSUpdate and :TSInstall <language>

Plug 'google/vim-jsonnet'                  " Jsonnet filetype support

call plug#end()

" Language Server
lua << EOF
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local on_attach = function(client, bufnr)
  -- enable nvim-lua/completion-nvim plugin
  require('completion').on_attach()

  -- enable pierreglaser/folding-nvim plugin
  require('folding').on_attach()

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- use LSP for omnifunc
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- if language server supports textDocument/formatting, run it automatically on save
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]], false)
  end
end

require('lspconfig').gopls.setup {
  cmd = { vim.env.GOPATH .. '/bin/gopls' },
  on_attach = on_attach,
  settings = {
    gopls = {
      buildFlags = { "-tags=integration" },
    }
  }
}
EOF

" Tree-sitter
lua << EOF
-- must run TSInstall {language} to install parsers
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}

EOF

" nvim-lua/completion-nvim
let g:completion_trigger_on_delete = 1  " refresh autocomplete menu after hitting delete
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_ignore_case = 1

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"|   " use tab to navigate down autocomplete menu
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"  " use shift-tab to navigate up autocomplete menu

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
    if get(g:, "journal_from_zsh", 0) == 1
      quitall  " easy close back to shell
    else
      quit  " quit original tab
    endif
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

" NetRW Bugfix (doesn't work because of https://github.com/vim/vim/issues/4738)
" TODO: remove when bug is fixed
let g:netrw_nogx=1

" This is just temporary workaround until the above issue is truly
" resolved.
" https://github.com/vim/vim/issues/4738#issuecomment-830820565
" https://bugzilla.suse.com/show_bug.cgi?id=1173583
" (https://bugzilla.suse.com/show_bug.cgi?id=1173583)
" gh#vim/vim#4738
function! OpenURLUnderCursor()
  let s:uri = expand('<cfile>')
  echom "s:uri = " . s:uri
  if s:uri != ''
    exec "!open '".s:uri."'"
    :redraw!
  endif
endfunction
nnoremap gx :call OpenURLUnderCursor()<CR>

" General Key Bindings
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

" this is required because <C-i> and <tab> are literally the same keystroke so the <tab> mapping above breaks the
" default <C-i> 'jump forward' behavior. We remap <C-i> to <C-p> so <C-p> is 'jump forward' and <C-o> is jump back.
nnoremap <C-p> <C-i>

nnoremap <leader>y :%y<CR>|  " copy entire buffer

nnoremap <space> za|  " toggle fold

nnoremap <silent> <leader><space> :nohlsearch<CR>|  " remove search highlighting
