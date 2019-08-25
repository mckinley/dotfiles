#!/usr/bin/env bash

# USAGE:
# `./bootstrap.sh` will install or update home dotfiles.
# `./bootstrap.sh --force` will ignore any problems while installing or updating.
# `./bootstrap.sh --revert` will revert previous install or update. This can be done several times to go back in time until there are no backups available.

#cd "$(dirname "${BASH_SOURCE}")";
#
#BACKUP_DIR_NAME=".dotfile-backups";
#BACKUP=$(date +%s);
#SOURCE_DIR="./home";
#DESTINATION_DIR=~;
#LAST_BACKUP=$(ls -tr $DESTINATION_DIR/$BACKUP_DIR_NAME | tail -n 1);
#echo $LAST_BACKUP;
#
#function install() {
#  echo "Updating dotfiles...";
#  git pull origin master;
#
#  echo "Installing dotfiles...";
#  echo "backup directory: $BACKUP_DIR_NAME/$BACKUP";
#  echo "destination directory: $DESTINATION_DIR";
#
#	rsync -b --backup-dir="$BACKUP_DIR_NAME/$BACKUP" \
#		--exclude ".DS_Store" \
#		-avh --no-perms "$SOURCE_DIR/" "$DESTINATION_DIR";
#  echo "Install complete.";
#  echo "If any files were overwritten during the install process they were backed up at $BACKUP_DIR_NAME/$BACKUP. They can be restored by running \`./bootstrap.sh --revert\`.";
#  source ~/.bash_profile;
#}
#
#function uninstall() {
#  echo "Uninstalling dotfiles...";
#  echo "last backup: $LAST_BACKUP";
#	rsync \
#		--exclude ".DS_Store" \
#		-avh --no-perms "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP/" "$DESTINATION_DIR";
#  rm -rf "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP";
#  echo "Uninstall complete."
#	source ~/.bash_profile;
#}
#
#if [[ "$1" == "--revert" ]]; then
#  if [[ -d "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP" ]]; then
#    uninstall;
#  else
#    echo "No backups where found at $DESTINATION_DIR/$BACKUP_DIR_NAME.";
#  fi;
#elif [[ "$1" == "--force" || "$1" == "-f" ]]; then
#	install;
#elif [[ ! -z $LAST_BACKUP]] && [[ -d "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP" ]]; then
#  read -p "There is already a dotfile backup at $DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP. The backup stored there can be restored by running \`./bootstrap.sh --revert\`. However, if this script continues, the existing backup may be replaced by a new backup and lost forever. Would you like to continue? (y/n) " -n 1;
#  echo "";
#  if [[ $REPLY =~ ^[Yy]$ ]]; then
#    install;
#  fi;
#else
#  install;
#fi;
#
#unset install;
#unset uninstall;

function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

GIT_REMOTE="git@github.com:mckinley/dotfiles.git"
GIT_DIR="$HOME/.dotfiles"
BACKUPS_DIR="$HOME/.dotfile-backups"
RESOURCES_DIR="$HOME/.dotfile-resources"
TMP_DIR="$(dirname "${BASH_SOURCE}")/tmp"

function install {
    BACKUP_DIR="$BACKUPS_DIR/$(date +%Y-%m-%d-%s)"

    echo "Installing dotfiles..."
    echo "Creating backup: $BACKUP_DIR"

    rm -rf "$GIT_DIR"
    mkdir -p "$TMP_DIR"
    git clone --separate-git-dir=$GIT_DIR $GIT_REMOTE $TMP_DIR
    rsync --backup --recursive --checksum --verbose \
    --backup-dir="$BACKUP_DIR" \
    --exclude={.DS_Store,.git,.idea}  \
    "$TMP_DIR/" "$HOME/"
    rm -rf $TMP_DIR

    dotfiles config --local status.showUntrackedFiles no
    dotfiles remote add origin git@github.com:mckinley/dotfiles.git

    source ~/.bash_profile

    echo "Install complete."
}

function revert {
    LAST_BACKUP="$BACKUPS_DIR/$(ls -tr "$BACKUPS_DIR" | tail -n 1)"

    echo "Reverting dotfiles..."
    echo "Last backup: $LAST_BACKUP"

    rsync --recursive --checksum --verbose \
    --exclude ".DS_Store" \
    "$LAST_BACKUP/" "$HOME/"
    rm -rf "$LAST_BACKUP"
    source ~/.bash_profile

    echo "Revert complete."
}

install

#if [[ "$1" == "--revert" ]]; then
#  if [[ -d "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP" ]]; then
#    uninstall;
#  else
#    echo "No backups where found at $DESTINATION_DIR/$BACKUP_DIR_NAME.";
#  fi;
#elif [[ "$1" == "--force" || "$1" == "-f" ]]; then
#	install;
#elif [[ ! -z $LAST_BACKUP]] && [[ -d "$DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP" ]]; then
#  read -p "There is already a dotfile backup at $DESTINATION_DIR/$BACKUP_DIR_NAME/$LAST_BACKUP. The backup stored there can be restored by running \`./bootstrap.sh --revert\`. However, if this script continues, the existing backup may be replaced by a new backup and lost forever. Would you like to continue? (y/n) " -n 1;
#  echo "";
#  if [[ $REPLY =~ ^[Yy]$ ]]; then
#    install;
#  fi;
#else
#  install;
#fi;


# dotfiles checkout $TMP
# dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $2'} | xargs -I {} rsync -avh --no-perms {} ~/.dotfile-backups/$BACKUP

# cd ~/
# git clone --bare git@github.com:mckinley/dotfiles.git $HOME/.dotfiles
# function dotfiles {
#    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
# }
# #alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# mkdir -p ~/.dotfile-backups
# dotfiles checkout
# if [[ $? = 0 ]]; then
#   echo "Checked out config.";
#   else
#     echo "Backing up pre-existing dotfiles.";
#
#     # rsync -b --backup-dir="$BACKUP_DIR_NAME/$BACKUP" \
#     # --exclude ".DS_Store" \
#     # -avh --no-perms "$SOURCE_DIR/" "$DESTINATION_DIR";
#
#     rsync -a --files-from=/tmp/foo /usr
#     dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I {} rsync -a {} ~/.dotfile-backups/$BACKUP
# fi;
# dotfiles checkout
# dotfiles config status.showUntrackedFiles no
# cd -
