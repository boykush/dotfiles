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

### 3. GitHub 認証（ghtkn）

`gh auth login`は使わず、[ghtkn](https://github.com/suzuki-shunsuke/ghtkn)が発行する短命（8時間）のGitHub App User Access Tokenに統一する。

事前にdevice flowを有効にしたGitHub Appを1つ用意し、そのClient IDを`ghtkn/ghtkn.yaml`に記入しておく（Client IDは機密ではないためコミット可）。

`mise install`時（postinstall）に、`ghtkn auth`（device flow＝ブラウザ承認）と旧 gh ログインの破棄が自動実行される（対話端末のみ。CI/非対話ではスキップ）。これで認証とフォールバック遮断が揃い ghtkn に一本化される。

トークンは8時間で失効するが、失効後も git（HTTPS）/ gh が必要時に`ghtkn get`で device flow を自動起動するため、再`mise install`しなくても認証は継続する。

## パッケージ管理

- **Homebrew**: `Brewfile`で宣言的に管理
- **mise**: `mise/config.toml`で管理
- **GitHubトークン**: `ghtkn`で発行（git の credential helper / gh が利用）
