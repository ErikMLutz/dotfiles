# ==================================================================================================
# 
#                                              .zshrc
#
# ==================================================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set neovim as default editor
export EDITOR=nvim

# use bat for syntax highlighted man pages
export MANPAGER="sh -c 'col -bx | bat --language=man'"

# less options
export LESS="-aiqrR"

# --------------------------------------------------------------------------------------------------
#                                      oh-my-zsh configuration
# --------------------------------------------------------------------------------------------------

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom
export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  wd
  git
  docker
  docker-compose
  git-flow
  pip
  per-directory-history
  python
  virtualenv
  vi-mode
)

# source oh-my-zsh once to avoid slow downs
source $ZSH/oh-my-zsh.sh

# apply p10k theme
source ~/.p10k.zsh


# --------------------------------------------------------------------------------------------------
#                                           miscellaneous 
# --------------------------------------------------------------------------------------------------

# hook direnv into shell
eval "$(direnv hook zsh)"

# set Neovim to listen to /tmp/nvim so that commands can be sent to all Neovim instances
alias nvim="NVIM_LISTEN_ADDRESS=/tmp/nvim nvim"
