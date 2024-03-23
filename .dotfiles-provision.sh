#!/usr/bin/env bash

# `./dotfiles-provision.sh`
# Provision machine

echo "Provisioning machine..."

echo "- Installing Xcode Command Line Tools"
# https://developer.apple.com/download/more/?=command%20line%20tools
xcode-select --install

echo "- Installing Homebrew"
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "- Installing utilities"
brew install \
  coreutils \
  zsh \
  rsync \
  git \
  gh \
  vim \
  autojump \
  direnv \
  asdf

echo "- Installing all asdf managed tools with Homebrew to ensure that dependencies are installed"
cut -d' ' -f1 .tool-versions | xargs -tI{} brew install {}

echo "- Installing asdf plugins"
cut -d' ' -f1 .tool-versions | xargs -tI{} asdf plugin add {}

echo "- Installing asdf managed tools"
asdf install
asdf reshim

echo "- Installing Oh My Zsh"
# https://github.com/ohmyzsh/ohmyzsh#unattended-install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
echo "- Review the files .zshrc.pre-oh-my-zsh and .zshrc and merge the changes. Then you may remove the .zshrc.pre-oh-my-zsh file."

echo "- Installing zsh theme"
# https://github.com/romkatv/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

echo "- Installing applications"
[[ ! -d "/Applications/Google Chrome.app" ]] && brew install --cask google-chrome
[[ ! -d "/Applications/Rectangle.app" ]] && brew install --cask rectangle
[[ ! -d "/Applications/Visual Studio Code.app" ]] && brew install --cask visual-studio-code

echo "- Changing shell to zsh"
chsh -s "$(which zsh)"

echo "Provision complete."
echo "Please check homebrew output for any required manual steps."
