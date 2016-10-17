# List directory contents
alias sl=ls
alias ls='ls -G'        # Compact view, show colors
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -al'
alias l='ls -a'
alias l1='ls -1'

alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back

alias date='gdate'

alias z='zeus'
alias s='spring'
alias delbranches='git co master && git branch | grep -v \* | xargs git branch -D && git remote prune origin'
alias delmerged='git co master && git branch --merged | grep -v \* | xargs git branch -D && git remote prune origin'
