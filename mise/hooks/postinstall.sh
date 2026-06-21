#!/bin/bash

# シンボリックリンク作成
ln -nfs ~/dotfiles/.zprofile ~/.zprofile
ln -nfs ~/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/dotfiles/git ~/.config/git
ln -nfs ~/dotfiles/ghostty ~/.config/ghostty
ln -nfs ~/dotfiles/gitui ~/.config/gitui
ln -nfs ~/dotfiles/helix ~/.config/helix
ln -nfs ~/dotfiles/ghtkn ~/.config/ghtkn
ln -nfs ~/dotfiles/claude-code/settings.json ~/.claude/settings.json
ln -nfs ~/dotfiles/claude-code/statusline.sh ~/.claude/statusline.sh
ln -nfs ~/dotfiles/claude-code/claude-dev.json ~/.claude/claude-dev.json
ln -nfs ~/dotfiles/claude-code/skills ~/.claude/skills
ln -nfs ~/dotfiles/claude-code/hooks ~/.claude/hooks
ln -nfs ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

# gh の旧ログイン（長命トークン）は使わず ghtkn に一本化する。保存トークンが
# 残っていれば破棄してフォールバックを断つ。ローカル処理のみ(~20ms)・冪等で、
# gh 未導入や未ログインでも安全に no-op（revoke はしない）。
command -v gh >/dev/null 2>&1 && gh auth logout --hostname github.com </dev/null >/dev/null 2>&1 || true

# ghtkn で事前認証（device flow）。enter フックを廃止したので明示的な mise install 時のみ走る。
# device flow は対話端末が必須。制御端末(/dev/tty)が無い CI/非対話ではスキップし無限ハングを防ぐ。
if command -v ghtkn >/dev/null 2>&1; then
  if { true >/dev/tty; } 2>/dev/null; then
    ghtkn auth </dev/tty >/dev/tty 2>&1 || true
  else
    echo "[postinstall] 非対話のため ghtkn auth をスキップ（対話端末で mise install すれば認証されます）" >&2
  fi
fi
