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

## install tools
exists=$(brew list)
for f (
  zellij
  fzf
  ripgrep
  exa
  zoxide
  git-delta
  gitui
  bat
  procs
  starship
  neovim
)
do
  if ((! exists[(Ie)$f] )); then
    echo "[INFO] install $f"
    brew install $f
  else
    echo "[INFO] $f is already installed"
  fi
done
## for neovim
if [ ! -d "~/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
  echo "[INFO] install packer.nvim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
  echo "[INFO] packer.nvim is already installed"
fi

# install applications
exists=$(brew list --cask)
for f (
  google-chrome
  wezterm
  font-hack-nerd-font
  alfred
  visual-studio-code
  intellij-idea-ce
  cmd-eikana
)
do
  if ((! exists[(Ie)$f] )); then
    echo "[INFO] install $f"
    brew install --cask $f
  else
    echo "[INFO] $f is already installed"
  fi
done
brew tap homebrew/cask-fonts

# setup config
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

## link wezterm config
ln -nfs ~/dotfiles/wezterm ~/.config/wezterm

## link neovim config
ln -nfs ~/dotfiles/nvim ~/.config/nvim

## link gitui config
ln -s ~/dotfiles/gitui/key_config.ron ~/Library/Application\ Support/gitui/key_config.ron

