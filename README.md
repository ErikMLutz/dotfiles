# dotfiles

## Installation

### Dependencies

`yadm` is the only dependency for installing these dotfiles. You can install it directly to your $PATH with:

```bash
curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
chmod a+x /usr/local/bin/yadm
```

### Steps

```bash
# clone this repository, accept prompt to run bootstrap script
yadm clone https://github.com/ErikMLutz/dotfiles.git
```

## Features

There are a lot of fun features in this repo!

### Generic Language Features

Generic language tools are implemented using the new [language server client](https://github.com/neovim/nvim-lspconfig)
and [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) integration in Neovim 0.5. To add a new language,
first configure the language server with
[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md):

```vim
lua << EOF
-- sample implementation for Go (hence `gopls`)
require('lspconfig').gopls.setup {
  ...
  on_attach = on_attach,  -- this function is implemented in `.vimrc`
}
EOF
```

The install the Tree-sitter parser, e.g. for Go:

```
:TSInstall go
```

These two tools provide things like:

* syntax highlighting
* go-to-definition
* autocomplete (via [nvim-lua/completion-nvim](https://github.com/nvim-lua/completion-nvim))
* linting/autoformatting
* file diagnostics and annotations

If more functionality is needed, e.g. build/execution commands, language specific plugins like
[fatih/vim-go](https://github.com/fatih/vim-go) can be installed. In these cases, conflicting functionatlity (e.g.
completion) should be disabled for the plugin in favor of the more universal implementation described above.

### DDev

`ddev` is a CLI utility that is currently used to rapidly change color themes. Themes are sourced from
[chriskempson/base16-shell](https://github.com/chriskempson/base16-shell), which also has an equivalent Vim plugin.
With a little shell magic the `ddev` theme tool will let you choose one of these themes and then automatically sync it
with `oh-my-zsh` (Powerlevel10k), `tmux`, and `nvim`. So theming will be consistent across the whole environment!

### FZF Extensions

As set of wrappers for [junegunn/fzf](https://github.com/junegunn/fzf) are provided that let you rapidly navigate your
system. You can see the full list of features here in the `f --help` output. All functions will open an interactive
`fzf` prompt with a list of relevant search results to filter through and navigate to.

```
Usage: f [-hq] [--help ] [--quiet] subcommand [ subcommand opts ]
  f                           Open an iteractive file search session.

Options:
  -h, --help                  Display this help message.
  -q, --quiet                 Suppress any unncessary output.
Subcommands:
  cd [opts] [dir]             Change to a subdirectory.
  popd                        Change to a directory on your stack.
  wd                          Change to a directory in your warp points.
  z                           Change to a directory based on 'frecency'.
  nvim                        Open a file based on file name.
  tags                        Open a file based on ctags.
```

#### Searching Hidden Files

By default FZF will not list hidden files because `--hidden` is not specified in the `FZF_DEFAULT_COMMAND` variable that
is set in `.zshrc`. To override this behavior for specific hidden files or directories create a `.ignore` file in the
project root where you are searching and add a negative assertion like `!.cache/` or `.env`.

### Vim Tools

#### Quick Access Journal

From anywhere in Vim you can press `<leader>j` to pull up a quick access journal. The journal is opened in a focused
reading mode that leverages [junegunn/goyo.vim](https://github.com/junegunn/goyo.vim) and
[junegunn/limelight.vim](https://github.com/junegunn/limelight.vim). The same keystroke will hide the journal and return
you to the previous buffer you were working on. Each time you leave the journal its contents and view are saved so that
you always return to the same state you left.

Additionally, from any shell the alias `j` will open Vim to the journal. The `<leader>j` keystroke will exit Vim if the
journal is opened with this method.
