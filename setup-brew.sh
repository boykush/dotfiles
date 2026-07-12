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

# install packages from Brewfile（GUI アプリ / フォントのみ）
brew bundle --file=~/dotfiles/Brewfile

# CLI ツールの導入は `./bin/mise install`、~/.config/mise を含む dotfiles の
# シンボリックリンクは `./bin/mise dotfiles apply` が行う（README 参照）。
