#!/bin/bash

# brew install (GUIアプリ、フォント、CLIツール)
brew_tools=(procs arc wezterm ghostty font-hack-nerd-font visual-studio-code)
installed=$(brew list)
for tool in "${brew_tools[@]}"; do
  if ! echo "$installed" | grep -q "^${tool}$"; then
    echo "[INFO] install $tool"
    brew install "$tool"
  else
    echo "[INFO] $tool is already installed"
  fi
done

# シンボリックリンク作成
ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/dotfiles/git ~/.config/git
ln -nfs ~/dotfiles/zellij ~/.config/zellij
ln -nfs ~/dotfiles/wezterm ~/.config/wezterm
ln -nfs ~/dotfiles/ghostty ~/.config/ghostty
ln -nfs ~/dotfiles/nvim ~/.config/nvim

# packer.nvimインストール
PACKER_PATH=~/.local/share/nvim/site/pack/packer/start/packer.nvim
if [ ! -d "$PACKER_PATH" ]; then
  echo "[INFO] install packer.nvim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
else
  echo "[INFO] packer.nvim is already installed"
fi
