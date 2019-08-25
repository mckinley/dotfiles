#!/usr/bin/env bash

# USAGE:
# `./bootstrap.sh` will install or update home dotfiles.
# `./bootstrap.sh --revert` will revert previous install or update. This can be done several times to go back in time until there are no backups available.

# WIP
provision() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew install autojump
  brew install bash-git-prompt
  brew install git
  brew install direnv
  brew install hub
  brew install postgresql && brew services start postgresql
  brew tap heroku/brew && brew install heroku

  brew install asdf
  brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc unzip curl
  # what requires this?
  brew install openssl libyaml libffi

  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby 2.6.3
  asdf global ruby 2.6.3

  brew install gpg
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs 10.16.3
  asdf global nodejs 10.16.3
}

GIT_REMOTE="git@github.com:mckinley/dotfiles.git"
GIT_DIR="$HOME/.dotfiles"
BACKUPS_DIR="$HOME/.dotfile-backups"
RESOURCES_DIR="$HOME/.dotfile-resources"
TMP_DIR="$(dirname "${BASH_SOURCE}")/tmp"

dotfiles() {
  git --git-dir=$GIT_DIR --work-tree=$HOME $@
}

install() {
  BACKUP_DIR="$BACKUPS_DIR/$(date +%Y-%m-%d-%s)"

  echo "Installing dotfiles..."
  echo "Creating backup: $BACKUP_DIR"

  rm -rf "$GIT_DIR"
  mkdir -p "$TMP_DIR"
  git clone --separate-git-dir=$GIT_DIR $GIT_REMOTE $TMP_DIR
  rsync --backup --recursive --checksum --verbose \
    --backup-dir="$BACKUP_DIR" \
    --exclude={.DS_Store,.git,.idea} \
    "$TMP_DIR/" "$HOME/"
  rm -rf $TMP_DIR
  dotfiles config --local status.showUntrackedFiles no
  dotfiles remote add origin git@github.com:mckinley/dotfiles.git
  source ~/.bash_profile

  echo "Install complete."
}

revert() {
  LAST_BACKUP="$BACKUPS_DIR/$(ls -tr "$BACKUPS_DIR" | tail -n 1)"

  if [ -z "$(ls $BACKUPS_DIR)" ]; then
    echo "No backups where found at $BACKUPS_DIR."
    return
  fi

  echo "Reverting dotfiles..."
  echo "Last backup: $LAST_BACKUP"

  rsync --recursive --checksum --verbose \
    --exclude ".DS_Store" \
    "$LAST_BACKUP/" "$HOME/"
  rm -rf "$LAST_BACKUP"
  source ~/.bash_profile

  echo "Revert complete."
}

if [[ "$1" == "--revert" ]]; then
  revert
else
  install
fi
