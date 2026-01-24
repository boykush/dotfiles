#!/bin/bash

# brew install (GUIアプリ、フォント、CLIツール)
brew_tools=(arc ghostty font-hack-nerd-font visual-studio-code)
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
ln -nfs ~/dotfiles/ghostty ~/.config/ghostty
ln -nfs ~/dotfiles/gitui ~/.config/gitui
ln -nfs ~/dotfiles/helix ~/.config/helix
ln -nfs ~/dotfiles/claude-code/settings.json ~/.claude/settings.json
