#!/bin/zsh

## sh エミュレーションモード
emulate -R sh

# install brew
if ! which brew > /dev/null; then
  echo "[INFO] install brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "[INFO] brew is already installed"
fi

# install packages from Brewfile
brew bundle --file=~/dotfiles/Brewfile

# setup config
## make directory .config
mkdir -p ~/.config

## link mise config
ln -nfs ~/dotfiles/mise ~/.config/mise
