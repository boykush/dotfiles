#!/bin/bash

# シンボリックリンク作成
ln -nfs ~/dotfiles/.zprofile ~/.zprofile
ln -nfs ~/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/dotfiles/git ~/.config/git
ln -nfs ~/dotfiles/ghostty ~/.config/ghostty
ln -nfs ~/dotfiles/gitui ~/.config/gitui
ln -nfs ~/dotfiles/helix ~/.config/helix
ln -nfs ~/dotfiles/claude-code/settings.json ~/.claude/settings.json
ln -nfs ~/dotfiles/claude-code/claude-dev.json ~/.claude/claude-dev.json
ln -nfs ~/dotfiles/claude-code/hooks ~/.claude/hooks
ln -nfs ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

if [ -L ~/.claude/skills ]; then
  unlink ~/.claude/skills
fi
mkdir -p ~/.claude/skills

if [ -e ~/.apm ] && [ ! -L ~/.apm ]; then
  mv ~/.apm ~/.apm.backup.$(date +%Y%m%d%H%M%S)
fi
ln -nfs ~/dotfiles/apm ~/.apm

# APM-managed agent dependencies. Keep this best-effort so a transient
# network or package-manager issue does not break the rest of dotfiles setup.
if mise which apm >/dev/null 2>&1; then
  (
    cd ~/dotfiles/apm &&
      mise exec -- apm install --global
  ) || echo "warning: APM install skipped or failed" >&2
else
  echo "warning: apm is not installed yet; run 'mise install' again after github:microsoft/apm installs" >&2
fi
