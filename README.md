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

### 3. GitHub 認証

既定は `gh auth login`。ghtkn を使わない環境は `gh auth login` するだけ（git も gh も gh の保存トークンを利用）。

GitHub App の短命トークン（8時間／[ghtkn](https://github.com/suzuki-shunsuke/ghtkn)）を使う環境は:

1. device flow を有効にした GitHub App を用意し、Client ID を `ghtkn/ghtkn.yaml` に記入（機密ではないためコミット可）。
2. `mise run ghtkn:on` で切り替え（`~/.gitconfig.ghtkn` 作成＋`ghtkn auth`＝device flow）。トークン失効後も `mise run ghtkn:on` か `ghtkn auth` で復帰。戻すときは `mise run ghtkn:off`。

## パッケージ管理

- **Homebrew**: `Brewfile`で宣言的に管理
- **mise**: `mise/config.toml`で管理
- **GitHub認証**: 既定は `gh auth login`、任意で `ghtkn`（GitHub App 短命トークン）に切替可
