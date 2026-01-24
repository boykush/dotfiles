#!/bin/zsh

## sh エミュレーションモード
emulate -R sh

# setup terminal
## set zsh config
ln -nfs ~/dotfiles/.zprofile ~/.zprofile
ln -nfs ~/dotfiles/.zshrc ~/.zshrc

# install tools
## install brew
if ! which brew > /dev/null; then
  echo "[INFO] install brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "[INFO] brew is already installed"
fi

## install mise
if ! brew list mise > /dev/null 2>&1; then
  echo "[INFO] install mise"
  brew install mise
else
  echo "[INFO] mise is already installed"
fi

# setup config
## make directory .config
mkdir -p ~/.config

## link mise config
ln -nfs ~/dotfiles/mise ~/.config/mise
