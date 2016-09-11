#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

BACKUP_DIR_NAME="dotfile-backups";
SOURCE_DIR="./home";
DESTINATION_DIR=~;

function install() {
  echo "Updating dotfiles...";
  git pull origin master;

  echo "Installing dotfiles...";
  echo "backup directory: $BACKUP_DIR_NAME";
  echo "destination directory: $DESTINATION_DIR";

	rsync -b --backup-dir="$BACKUP_DIR_NAME" \
		--exclude ".DS_Store" \
		-avh --no-perms "$SOURCE_DIR/" "$DESTINATION_DIR";
  echo "";
  echo "If any files were overwritten during the install process they were backed up at ~/dotfile-backup. They can be restored by running './bootstrap.sh --revert'.";
  source ~/.bash_profile;
}

function uninstall() {
	rsync \
		--exclude ".DS_Store" \
		-avh --no-perms "$DESTINATION_DIR/$BACKUP_DIR_NAME/" "$DESTINATION_DIR";
  rm -rf "$DESTINATION_DIR/$BACKUP_DIR_NAME";
  "Uninstall complete."
	source ~/.bash_profile;
}

if [ "$1" == "--revert" ]; then
  uninstall;
elif [ "$1" == "--force" -o "$1" == "-f" ]; then
	install;
elif [ -d "$DESTINATION_DIR/$BACKUP_DIR_NAME" ]; then
  read -p "There is already a dotfile-backup directory in your home directory. The backups stored there can be restored by running \`./bootstrap.sh \`. However, if this script continues, existing backups may be replaced by new backups from the home directory and lost forever. Would you like to continue? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install;
  fi;
else
  install;
fi;

unset install;
unset uninstall;
