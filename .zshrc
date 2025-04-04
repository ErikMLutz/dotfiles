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

# add DDev commands to path
export PATH=~/.ddev/bin:~/.dotfiles/bin:$PATH

# use bat for syntax highlighted man pages
export MANPAGER="sh -c 'col -bx | bat --language=man'"

# less options
export LESS="-aiqrR"

# add DDev function completions, deduplicate path
export fpath=(~/.ddev/completion $fpath)
typeset -aU fpath

# --------------------------------------------------------------------------------------------------
#                                              DDev
# --------------------------------------------------------------------------------------------------

# source internal ddev utility and extra utilites
source ~/.ddev/source/ddev
source ~/.ddev/source/fzf-extensions

# run ddev initialization only once, NB this needs to be run prior to anything that requires
# DDev's color variables, e.g. FZF_DEFAULT_OPTS and ~/.p10k.zsh
ddev init

# establish precmd function
precmd () {
  # sync theme to account for changes from other panes
  ddev theme sync
}

# --------------------------------------------------------------------------------------------------
#                                      oh-my-zsh configuration
# --------------------------------------------------------------------------------------------------

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom
export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  wd
  git
  git-flow
  docker
  docker-compose
  kubectl
  pip
  python
  virtualenv
  vi-mode
  per-directory-history
)

# source oh-my-zsh once to avoid slow downs
source $ZSH/oh-my-zsh.sh

# --------------------------------------------------------------------------------------------------
#                                          zsh configuration
# --------------------------------------------------------------------------------------------------

# configure zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$COLOR_21,bg=$BACKGROUND_COLOR"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(expand-or-complete $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# configure zsh-syntax-highlighting to show brackets
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# enable short option stacking with docker autosuggestions (e.g. autocomplete after '-it')
zstyle ":completion:*:*:docker:*" option-stacking yes
zstyle ":completion:*:*:docker-*:*" option-stacking yes

# source autosuggestions and syntax highlighting
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# source function to toggle per directory history using ^g
source $ZSH/plugins/per-directory-history/per-directory-history.zsh

# stop pasted text from being highlighted
zle_highlight=("paste:none")

# disable autosuggestions while pasting, this greatly speeds up how fast pasted
# text can be inserted in the line. This also fixes an issue where annoying and wrong
# autosuggestsion will be displayed after pasting in text
# https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-483938570
paste_init() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

paste_finish() {
  zle -N self-insert $OLD_SELF_INSERT
  unset OLD_SELF_INSERT
}
zstyle ":bracketed-paste-magic" paste-init paste_init
zstyle ":bracketed-paste-magic" paste-finish paste_finish

# prevent autosuggestions after paste and execute
# https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-515415202
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste accept-line)
typeset -aU ZSH_AUTOSUGGEST_CLEAR_WIDGETS

# KEY BINDINGS
bindkey "^[OA" up-line-or-history                   # (UpArrowKey) vi-mode defaults to up-line-or-beginning-search
bindkey "^[OB" down-line-or-history                 # (DownArroyKey) vi-mode defaults to down-line-or-beginning-search
bindkey "^K"   kill-line                            # (ctrl-l) delete line to right of cursor
bindkey "^J"   backward-kill-line                   # (ctrl-h) delete line to left of cursor
bindkey "^U"   undo                                 # (ctrl-u) undo last edit
bindkey "^R"   redo                                 # (ctrl-r) redo last edit
bindkey "^S"   history-incremental-search-backward  # (ctrl-s) search history
bindkey "^P"   forward-word                         # (ctrl-p) move back one word
bindkey "^O"   backward-word                        # (ctrl-o) move forward one word

# --------------------------------------------------------------------------------------------------
#                                               fzf
# --------------------------------------------------------------------------------------------------

export FZF_DEFAULT_OPTS="\
  --reverse --cycle \
  --bind change:top \
  --color bg:${BACKGROUND_COLOR/default/-1},bg+:$COLOR_01 \
  --color fg:${FOREGROUND_COLOR/default/-1},fg+:$COLOR_08 \
  --color hl:$COLOR_07,hl+:$COLOR_07 \
  --color info:$COLOR_05,prompt:$COLOR_05 \
  --color pointer:$COLOR_05,marker:$COLOR_05 \
  --color header:$COLOR_16,spinner:$COLOR_07 \
  --color border:${FOREGROUND_COLOR/default/-1} \
  --color preview-fg:${FOREGROUND_COLOR/default/-1} \
  --color preview-bg:${BACKGROUND_COLOR/default/-1} \
  "
export FZF_DEFAULT_COMMAND='rg --files'

# --------------------------------------------------------------------------------------------------
#                                           miscellaneous 
# --------------------------------------------------------------------------------------------------

# source z functions
[[ -r "$HOME/.ddev/source/z.sh" ]] && source $HOME/.ddev/source/z.sh

# hook direnv into shell
eval "$(direnv hook zsh)"

# set Neovim to listen to /tmp/nvim so that commands can be sent to all Neovim instances
alias nvim="NVIM_LISTEN_ADDRESS=/tmp/nvim nvim"

# quick access to journal in Vim
alias j="nvim +'let g:journal_from_zsh=1' +'call ToggleJournal()'"

# open cheatsheet
alias cheat="bat ~/.cheatsheet.md"

# apply p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source any local settings from a separate file
[ -e ~/.zshrc.local ] || [ -L ~/.zshrc.local ] && source ~/.zshrc.local

autoload -U +X bashcompinit && bashcompinit

# git aliases for cleaning up untracked local branched
alias git-list-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'

# --------------------------------------------------------------------------------------------------
#                                            easter eggs
# --------------------------------------------------------------------------------------------------

# When's the next Hohmann transfer window to mars?
whenmars () {
  local rsp
  local year_days

  rsp=$(
    curl -s \
      -d "activity=retrieve" \
      -d "coordinate=1" \
      -d "equinox=2" \
      -d "object=04" \
      -d "object2=42" \
      -d "resolution=001" \
      -d "start_year=$(date -u +%Y)" \
      -d "start_day=$(date -u +%j)" \
      -d "stop_year=$(($(date -u +%Y) + 3))" \
      -d "stop_day=366" \
      https://omniweb.gsfc.nasa.gov/cgi/models/helios1.cgi
  )

  year_days=$(
    echo $rsp \
      | tail +10 \
      | sed '$d' \
      | grep '315\.\d' \
      | head -n 1 \
      | cut -f 1,2 -d ' '
  )

  echo $year_days \
    | xargs -L1 bash -c \
      'echo "The next Hohmann transfer window to Mars is $(date -v$0y -v1d -v1m -v+$1d -v-1d -u +%Y-%m-%d)."'
}
