#!/bin/zsh

## sh エミュレーションモード
emulate -R sh

# setup terminal
## set zsh config
ln -nfs ~/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

# install tools
## install brew
if ! which brew > /dev/null; then
  echo "[INFO] install brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "[INFO] brew is already installed"
fi

# setup config
## make directory .config
mkdir -p ~/.config

## link nushell config
ln -nfs ~/dotfiles/nushell ~/.config/nushell

## link git config
ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/dotfiles/git ~/.config/git

## link idea vim
ln -nfs ~/dotfiles/ideavim/.ideavimrc ~/.ideavimrc
ln -nfs ~/dotfiles/intellij/.ideavimrc ~/.ideavimrc

## link zellij config
ln -nfs ~/dotfiles/zellij ~/.config/zellij

## link wezterm config
ln -nfs ~/dotfiles/wezterm ~/.config/wezterm

## link neovim config
ln -nfs ~/dotfiles/nvim ~/.config/nvim
