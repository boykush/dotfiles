# dotfiles

miseを中心とした開発環境の設定ファイル群です。

## セットアップ

### 1. brewとmiseのインストール

```bash
./setup-brew.sh
```

### 2. ツールのインストール

```bash
mise install
```

これでセットアップは完了です。

## パッケージ管理

- **Homebrew**: `Brewfile`で宣言的に管理
- **mise**: `mise/config.toml`で管理
