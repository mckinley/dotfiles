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
  zsh \
  rsync \
  git \
  gh \
  vim \
  autojump \
  direnv \
  asdf

# dependencies for ruby-build which is used by asdf-ruby
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
brew install openssl@1.1 openssl@3 readline libyaml gmp

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

echo "- Installing powerlevel10k"
# https://github.com/romkatv/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

echo "- Downloading p10k fonts"
curl --create-dirs -LO --output-dir ~/powerlevel10k-fonts/ "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl --create-dirs -LO --output-dir ~/powerlevel10k-fonts/ "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl --create-dirs -LO --output-dir ~/powerlevel10k-fonts/ "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl --create-dirs -LO --output-dir ~/powerlevel10k-fonts/ "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

echo "- Font files for powerlevel10k have been downloaded to ~/powerlevel10k-fonts/. Please install them manually and remove the ~/powerlevel10k-fonts/ directory."
echo "- Configure your terminal to use the new font: Open Terminal → Preferences → Profiles → Text, click Change under Font and select MesloLGS NF family."

echo "- Installing applications"
[[ ! -d "/Applications/Google Chrome.app" ]] && brew install --cask google-chrome
[[ ! -d "/Applications/Rectangle.app" ]] && brew install --cask rectangle
[[ ! -d "/Applications/Visual Studio Code.app" ]] && brew install --cask visual-studio-code

echo "- Changing shell to zsh"
chsh -s "$(which zsh)"

echo "Provision complete."
echo "Please check homebrew output for any required manual steps."
