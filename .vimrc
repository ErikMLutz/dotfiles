" VIM Configuration

" Filetype plugin files (<C-w>gf to open file under cursor in new tab)
" ~/.config/nvim/after/ftplugin/markdown.vim
" ~/.config/nvim/after/ftplugin/rego.vim
" ~/.config/nvim/after/ftplugin/go.vim

" General
set secure                 " prevent dangerous commands when loading local config files
set exrc                   " load local config files if they exist
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

" Providers
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog  = '/usr/bin/python3'

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
Plug 'neovim/nvim-lspconfig'               " configurations for built in language server client
Plug 'hrsh7th/nvim-cmp'                    " completion engine
Plug 'hrsh7th/cmp-nvim-lsp'                " native LSP source for completion engine
Plug 'hrsh7th/cmp-buffer'                  " completion from buffer words
Plug 'hrsh7th/cmp-path'                    " completion for filesystem paths
Plug 'hrsh7th/cmp-cmdline'                 " completion for Vim's command and search modes (':' and '/')
Plug 'hrsh7th/cmp-nvim-lsp-signature-help' " completion for function signatures with current parameter emphasized
Plug 'sirver/ultisnips'                    " snippet engine, required for nvim-cmp
Plug 'honza/vim-snippets'                  " snippets for ultisnips
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " nvim-cmp integration for ultisnips
Plug 'nvim-treesitter/nvim-treesitter'     " generic syntax parsing, run :TSUpdate and :TSInstall <language>
Plug 'google/vim-jsonnet'                  " Jsonnet filetype support

Plug 'salkin-mada/openscad.nvim'           " OpenSCAD support
call plug#end()

" neovim/nvim-lspconfig
lua << EOF
-- https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- if language server supports textDocument/formatting, run it automatically on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_exec([[
      augroup lsp
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
      augroup END
    ]], false)
  end
end

-- include hrsh7th/cmp-nvim-lsp capabilites
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

if vim.env.GOPATH then
  require('lspconfig').gopls.setup {
    cmd = { vim.env.GOPATH .. '/bin/gopls' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        buildFlags = { "-tags=integration" },
      }
    },
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }

end

require('lspconfig').clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--enable-config"}
}
EOF

" nvim-treesitter/nvim-treesitter
lua << EOF
-- must run TSInstall {language} to install parsers
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}
EOF

" hrsh7th/cmp-nvim-lsp
lua << EOF
-- https://github.com/hrsh7th/nvim-cmp#recommended-configuration
-- Setup nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  },
  completion = {
    autocomplete = false,
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  })
})
EOF

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
  \    'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
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
    new
    execute 'edit' g:journal_file
    silent! loadview  " load stored view so we always return to the same place
    Goyo120
  else
    mkview  " store our view of the file so it can be restored
    Goyo!   " quit Goyo mode
    silent write
    if get(g:, "journal_from_zsh", 0) == 1
      quitall  " easy close back to shell
    else
      quit  " quit original tab
    endif
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
