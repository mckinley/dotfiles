include () {
  [[ -s "$1" ]] && . "$1"
}

exists () {
  hash "$1" &> /dev/null
}

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

export EDITOR=vim
export PATH="$PATH:$HOME/scripts"

include ~/.bash_aliases
include ~/.bash_functions

include $(brew --prefix)/etc/profile.d/autojump.sh
include $(brew --prefix)/etc/bash_completion

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  . "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

if exists direnv; then
    eval "$(direnv hook bash)"
fi

[[ $(gem list hub -i) == "true" ]] && eval "$(hub alias -s)"

export NVM_DIR="$HOME/.nvm"
include "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
include ~/.rvm/scripts/rvm # Load RVM into a shell session *as a function*
