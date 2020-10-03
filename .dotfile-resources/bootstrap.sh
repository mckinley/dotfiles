#!/usr/bin/env bash

# USAGE:
# `./bootstrap.sh` will install or update home dotfiles.
# `./bootstrap.sh --provision` will install software.
# `./bootstrap.sh --revert` will revert previous install or update. This can be done several times to go back in time until there are no backups available.

GIT_REMOTE="git@github.com:mckinley/dotfiles.git"
GIT_DIR="$HOME/.dotfiles"
BACKUPS_DIR="$HOME/.dotfile-backups"
RESOURCES_DIR="$HOME/.dotfile-resources"
SOURCE_FILE="$HOME/.zshrc"
TMP_DIR="$(dirname "${BASH_SOURCE}")/tmp"

provision() {
  #  Install Xcode Command Line Tools
  #  https://developer.apple.com/download/more/?=command%20line%20tools
  xcode-select --install

  #  https://brew.sh/
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  #  https://formulae.brew.sh/formula/zsh
  brew install zsh
  #  https://ohmyz.sh/#install
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  #  https://github.com/wting/autojump#os-x
  brew install autojump

  #  https://github.com/magicmonty/bash-git-prompt#via-homebrew-on-mac-os-x
  brew install bash-git-prompt

  #  https://git-scm.com/
  brew install git

  #  https://direnv.net/docs/installation.html
  brew install direnv

  #  https://hub.github.com/
  brew install hub

  #  https://wiki.postgresql.org/wiki/Homebrew
  brew install postgresql && brew services start postgresql

  #  https://devcenter.heroku.com/articles/heroku-cli
  brew tap heroku/brew && brew install heroku

  #  https://asdf-vm.com/#/core-manage-asdf
  #  Dependencies
  brew install coreutils curl git
  #  Install
  brew install asdf

  #  https://github.com/asdf-vm/asdf-ruby#install
  #  Dependencies (ruby-build: https://github.com/rbenv/ruby-build/wiki#macos)
  #  optional, but recommended:
  brew install openssl readline
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby 2.6.6
  asdf global ruby 2.6.6

  #  https://github.com/asdf-vm/asdf-nodejs#install
  #  Dependencies (https://github.com/asdf-vm/asdf-nodejs#macos)
  brew install coreutils gpg
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  #  Import the Node.js release team's OpenPGP keys to main keyring
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
  asdf install nodejs 12.18.4
  asdf global nodejs 12.18.4

  #  https://classic.yarnpkg.com/en/docs/install#mac-stable
  brew install yarn

  mkdir -p "$TMP_DIR"
  git checkout git@github.com:lysyi3m/macos-terminal-themes.git "$TMP_DIR"
  open macos-terminal-themes/schemes/OceanicMaterial.terminal
  rm -rf "$TMP_DIR"
}

dotfiles() {
  git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"
}

install() {
  BACKUP_DIR="$BACKUPS_DIR/$(date +%Y-%m-%d-%s)"

  echo "Installing dotfiles..."
  echo "Creating backup: $BACKUP_DIR"

  rm -rf "$GIT_DIR"
  mkdir -p "$TMP_DIR"
  git clone --separate-git-dir="$GIT_DIR" $GIT_REMOTE "$TMP_DIR"
  rsync --backup --recursive --checksum --verbose \
    --backup-dir="$BACKUP_DIR" \
    --exclude={.DS_Store,.git,.idea} \
    "$TMP_DIR/" "$HOME/"
  rm -rf "$TMP_DIR"
  dotfiles config --local status.showUntrackedFiles no
  dotfiles remote add origin "$GIT_REMOTE"
  source "$SOURCE_FILE"

  echo "Install complete."
}

revert() {
  LAST_BACKUP="$BACKUPS_DIR/$(ls -tr "$BACKUPS_DIR" | tail -n 1)"

  if [ -z "$(ls "$BACKUPS_DIR")" ]; then
    echo "No backups where found at $BACKUPS_DIR."
    return
  fi

  echo "Reverting dotfiles..."
  echo "Last backup: $LAST_BACKUP"

  rsync --recursive --checksum --verbose \
    --exclude ".DS_Store" \
    "$LAST_BACKUP/" "$HOME/"
  rm -rf "$LAST_BACKUP"
  source "$SOURCE_FILE"

  echo "Revert complete."
}

if [[ "$1" == "--revert" ]]; then
  revert
elif [[ "$1" == "--provision" ]]; then
  provision
else
  install
fi
