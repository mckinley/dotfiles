# dotfiles

## Install dotfiles
- `cd` into the dotfiles project root.
- run `./.dotfile-resources/bootstrap.sh`.

## Revert dotfiles
- `cd` into the dotfiles project root.
- run `./.dotfile-resources/bootstrap.sh --revert`.

## Managing dotfiles

Once dotfiles is installed, the `dotfiles` command is available as an alias for `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME` in bash or zsh.
Manage files in the home directory as if they were in a git repository, but only files that are explicitly added are tracked.
Remember that the repository originally used to install dotfiles is not the repository affecting shell sessions or generally used to manage dotfiles.
To get started execute `dotfiles status` in the home directory.

## Preferences
- dock
- finder toolbar
- keyboard
- login items
- sharing
- sound
- trackpad

## Other programs
- Chrome
- Atom
- GitHub Desktop
- RubyMine
- Sourcetree
- Spectacle
- Spotify

## Ssh keys
- https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- https://devcenter.heroku.com/articles/keys
