#!/bin/zsh

## sh エミュレーションモード
emulate -R sh

# setup terminal
## set zsh config
ln -nfs ~/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

## make directory .config
mkdir -p ~/.config

## link git config
ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/dotfiles/git ~/.config/git

## link idea vim
ln -nfs ~/dotfiles/ideavim/.ideavimrc ~/.ideavimrc
ln -nfs ~/dotfiles/intellij/.ideavimrc ~/.ideavimrc

## link zellij config
ln -nfs ~/dotfiles/zellij ~/.config/zellij

## link alacritty config
ln -nfs ~/dotfiles/alacritty ~/.config/alacritty

## link neovim config
ln -nfs ~/dotfiles/nvim ~/.config/nvim

## link gitui config
ln -s ~/dotfiles/gitui/key_config.ron ~/Library/Application\ Support/gitui/key_config.ron

## install brew
if ! which brew > /dev/null; then
    echo "[INFO] install brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "[INFO] brew is already installed"
fi

## install zellij
if ! which zellij > /dev/null; then
    echo "[INFO] install zellij"
    brew install zellij
else
    echo "[INFO] zellij is already installed"
fi

## install alacritty
if ! which alacritty > /dev/null; then
    echo "[INFO] install alacritty"
    brew install --cask alacritty
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
else
    echo "[INFO] alacritty is already installed"
fi

# setup editor
## install neovim
if ! which nvim > /dev/null; then
    echo "[INFO] install neovim"
    brew install neovim
else
    echo "[INFO] neovim is already installed"
fi

## install packaer.nvim
if [ ! -d "~/.local/share/nvim/site/pack/packer" ]; then
    echo "[INFO] install packer.nvim"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
    echo "[INFO] packer.nvim is already installed"
fi

## install fzf
if ! which fzf > /dev/null; then
    echo "[INFO] install fzf"
    brew install fzf
else
    echo "[INFO] fzf is already installed"
fi

## install rg
if ! which rg > /dev/null; then
    echo "[INFO] install ripgrep"
    brew install ripgrep
else
    echo "[INFO] ripgrep is already installed"
fi

## install exa
if ! which exa > /dev/null; then
  echo "[INFO] install exa"
  brew install exa
else
  echo "[INFO] exa is already installed"
fi

## install zoxide
if ! which zoxide > /dev/null; then
  echo "[INFO] install zoxide"
  brew install zoxide
else
  echo "[INFO] zoxide is already installed"
fi

## install git-delta
if ! which delta > /dev/null; then
  echo "[INFO] install git-delta"
  brew install git-delta
else
  echo "[INFO] git-delta is already installed"
fi

## install Github CLI
if ! which gh > /dev/null; then
  echo "[INFO] install Github CLI"
  brew install gh
  gh config set pager delta
else
  echo "[INFO] Github CLI is already installed"
fi

## install gitui
if ! which gitui > /dev/null; then
    echo "[INFO] install gitui"
    brew install gitui
else
    echo "[INFO] gitui is already installed"
fi

## install bat
if ! which bat > /dev/null; then
    echo "[INFO] install bat"
    brew install bat
else
    echo "[INFO] bat is already installed"
fi

## install navi
if ! which navi > /dev/null; then
    echo "[INFO] install navi"
    brew install navi
else
    echo "[INFO] navi is already installed"
fi

## install procs
if ! which procs > /dev/null; then
    echo "[INFO] install procs"
    brew install procs
else
    echo "[INFO] procs is already installed"
fi

## install grex
if ! which grex > /dev/null; then
    echo "[INFO] install grex"
    brew install grex
else
    echo "[INFO] grex is already installed"
fi

## install starship
if ! which starship > /dev/null; then
    echo "[INFO] install starship"
    brew install starship
else
    echo "[INFO] starship is already installed"
fi

## install gawk
if ! which gawk > /dev/null; then
    echo "[INFO] install gawk"
    brew install gawk
else
    echo "[INFO] gawk is already installed"
fi

## install silicon
if ! which silicon > /dev/null; then
    echo "[INFO] install silicon"
    brew install silicon
else
    echo "[INFO] silicon is already installed"
fi

## install mcfly
if ! which mcfly > /dev/null; then
  echo "[INFO] install mcfly"
  brew tap cantino/mcfly
  brew install cantino/mcfly/mcfly
else
    echo "[INFO] mcfly is already installed"
fi
