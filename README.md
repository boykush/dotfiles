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

### 3. dotfiles の適用

`mise/config.toml` の `[dotfiles]` に定義したシンボリックリンクを張る（`~/.zshrc` や `~/.config/*` など）。`[tools]` と違い自動では張られないため明示実行する。冪等なので再実行しても既存の正しいリンクはそのまま。

```bash
mise dotfiles apply
```

適用状況は `mise dotfiles status` で確認できる。

### 4. GitHub 認証

既定は `gh auth login`。ghtkn を使わない環境は `gh auth login` するだけ（git も gh も gh の保存トークンを利用）。

GitHub App の短命トークン（8時間／[ghtkn](https://github.com/suzuki-shunsuke/ghtkn)）を使う環境は:

1. device flow を有効にした GitHub App を用意し、Client ID を `ghtkn/ghtkn.yaml` に記入（機密ではないためコミット可）。
2. `mise run ghtkn:on` で切り替え（`~/.gitconfig.ghtkn` 作成＋`ghtkn auth`＝device flow）。トークン失効後も `mise run ghtkn:on` か `ghtkn auth` で復帰。戻すときは `mise run ghtkn:off`。

## パッケージ管理

- **Homebrew**: `Brewfile`で宣言的に管理
- **mise**: `mise/config.toml`で管理
- **dotfiles**: `mise/config.toml`の`[dotfiles]`でシンボリックリンクを宣言的に管理（`mise dotfiles apply`で適用）
- **npm**: `mise/config.toml`の`NPM_CONFIG_REGISTRY`で既定レジストリを [Takumi Guard](https://shisho.dev/docs/t/guard/quickstart/)（悪意あるパッケージのブロックプロキシ）に設定
- **GitHub認証**: 既定は `gh auth login`、任意で `ghtkn`（GitHub App 短命トークン）に切替可
