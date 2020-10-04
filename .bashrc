alias ls='ls -G'
alias l='ls -a'
alias ll='ls -al'
alias la='ls -AF'
alias l1='ls -1'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias delbranches='git co master && git branch | grep -v \* | xargs git branch -D && git remote prune origin'
alias delmerged='git co master && git branch --merged | grep -v \* | xargs git branch -D && git remote prune origin'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dot=dotfiles
alias mine=rubymine

shopt -s histappend
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000

export EDITOR=vim
export PATH="$PATH:$HOME/scripts"

# https://formulae.brew.sh/formula/ruby-build
# ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.
# Note: this may interfere with building old versions of Ruby (e.g <2.4) that use OpenSSL <1.1.
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

include() {
  [[ -s "$1" ]] && . "$1"
}

exists() {
  hash "$1" &> /dev/null
}

HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
  source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi

include $(brew --prefix)/opt/asdf/asdf.sh
include $(brew --prefix)/etc/profile.d/autojump.sh

if exists direnv; then
    eval "$(direnv hook bash)"
fi

if exists hub; then
    eval "$(hub alias -s)"
fi
