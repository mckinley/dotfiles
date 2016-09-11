export PATH="$PATH:~/scripts"
export EDITOR=vim

export RUBY_GC_HEAP_INIT_SLOTS=600000
export RUBY_GC_MALLOC_LIMIT=59000000
export RUBY_HEAP_FREE_MIN=100000

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

source ~/.bash_aliases
source ~/.bash_functions

if [ -f /usr/local/share/chruby/chruby.sh ]; then
    source /usr/local/share/chruby/chruby.sh
fi
if [ -f /usr/local/share/chruby/auto.sh ]; then
    source /usr/local/share/chruby/auto.sh
fi

source ~/.git-completion.bash
source ~/.git-prompt.sh

PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

if [ "$(gem list hub -i)" == "true" ]; then
    eval "$(hub alias -s)"
fi

eval "$(direnv hook bash)"

if [ -f /usr/local/etc/bash_completion.d ]; then
    . /usr/local/etc/bash_completion.d
fi
