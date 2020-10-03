# dotfiles

## Install dotfiles
- `cd` into the dotfiles project root.
- run `./.dotfile-resources/bootstrap.sh`.

## Provision system for dotfiles
- `cd` into the dotfiles project root.
- run `./.dotfile-resources/bootstrap.sh --provision`.

## Revert dotfiles
- `cd` into the dotfiles project root.
- run `./.dotfile-resources/bootstrap.sh --revert`.

## Managing dotfiles

The repository originally cloned to install dotfiles is not the installation target. After installation, manage dotfiles from your home directory.
Once dotfiles is installed, the `dotfiles` command is available as an alias for `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME` in bash or zsh.
You can manage files in your home directory as if they were in a git repository, but only files that are explicitly added are tracked.
To get started execute `dotfiles status` in the home directory.

## Ssh keys
- https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- https://devcenter.heroku.com/articles/keys

## Bash and Zsh
Dotfiles assumes Zsh as the default shell. Bash dotfiles are also included but may not be actively maintained.
