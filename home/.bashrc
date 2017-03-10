include () {
  [[ -s "$1" ]] && . "$1"
}

exists () {
  hash "$1" &> /dev/null
}

export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

export EDITOR=vim

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

include ~/.bash_aliases
include ~/.bash_functions

include ~/.rvm/scripts/rvm # Load RVM into a shell session *as a function*
include $(brew --prefix)/etc/profile.d/autojump.sh
include $(brew --prefix)/etc/bash_completion
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  . "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

[[ $(gem list hub -i) == "true" ]] && eval "$(hub alias -s)"
if exists direnv; then
    eval "$(direnv hook bash)"
fi
