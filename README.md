# dotfiles

## Installation

### Dependencies

`yadm` is the main dependency for installing these dotfiles. You can install it directly to your $PATH with:

```bash
curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
chmod a+x /usr/local/bin/yadm
```

### Steps

```bash
# clone this repository
yadm clone https://github.com/ErikMLutz/dotfiles.git

# symlink alternate files based on machine
yadm alt

# run installation script
yadm bootstrap
```

## Features

There are a lot of fun features in this repo!

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
