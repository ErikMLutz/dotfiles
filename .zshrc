# ==================================================================================================
# 
#                                              .zshrc
#
# ==================================================================================================

# set neovim as default editor
export EDITOR=nvim

# use bat for syntax highlighted man pages
export MANPAGER="sh -c 'col -bx | bat --language=man'"

# less options
export LESS="-aiqrR"

# --------------------------------------------------------------------------------------------------
#                                           miscellaneous 
# --------------------------------------------------------------------------------------------------

# hook direnv into shell
eval "$(direnv hook zsh)"

# set Neovim to listen to /tmp/nvim so that commands can be sent to all Neovim instances
alias nvim="NVIM_LISTEN_ADDRESS=/tmp/nvim nvim"
