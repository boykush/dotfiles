# dotfiles

miseを中心とした開発環境の設定ファイル群です。

## セットアップ

新環境に mise を事前インストールする必要はない。リポジトリ同梱の `bin/mise`（`mise generate bootstrap` の出力＝自己インストールラッパー）が mise 本体を取得して実行する。

### 1. リポジトリ取得

```bash
git clone git@github.com:boykush/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. CLI ツールのインストール（mise 本体も bootstrap で自動取得）

```bash
./bin/mise install
```

`bin/mise` は初回に mise 本体を `~/.cache/mise` へ取得してから実行する（mise 未導入でも動く）。リポジトリ内で実行するため `mise/config.toml` がローカル config として読まれ、`[tools]` の CLI ツールが入る。埋込版は renovate が `min_version` と lockstep で追従するため floor を下回らない（任意で最新化するなら `./bin/mise self-update`）。

### 3. dotfiles の適用

`[dotfiles]` に定義したシンボリックリンク（`~/.zshrc` や `~/.config/*` など。mise 設定自身の `~/.config/mise` -> `~/dotfiles/mise` もここで張る）を適用する。`[tools]` と違い自動では張られないため明示実行する。冪等なので再実行しても既存の正しいリンクはそのまま。

```bash
./bin/mise dotfiles apply
```

適用状況は `./bin/mise dotfiles status` で確認できる。以降は新しいシェルで `~/dotfiles/bin` が PATH に入り、`mise` はこのラッパーに解決される。

### 4. GUI アプリ / フォント

GUI アプリ（arc / claude / codex-app / ghostty）は宣言的管理をやめ、各自手動でインストールする。頻繁に入れ替えず更新もアプリ自身が持つため管理の意義が薄く、設定ファイルは dotfiles（`mise dotfiles apply`）で管理される。

ghostty が主フォントに使う Hack Nerd Font のみ mise task で導入する（フォントは実行ファイルではなく `[tools]` では扱えないため task 化。`~/Library/Fonts` に配置）:

```bash
./bin/mise run setup:font
```

### 5. GitHub 認証

既定は `gh auth login`。ghtkn を使わない環境は `gh auth login` するだけ（git も gh も gh の保存トークンを利用）。

GitHub App の短命トークン（8時間／[ghtkn](https://github.com/suzuki-shunsuke/ghtkn)）を使う環境は:

1. device flow を有効にした GitHub App を用意し、Client ID を `ghtkn/ghtkn.yaml` に記入（機密ではないためコミット可）。
2. `mise run ghtkn:on` で切り替え（`~/.gitconfig.ghtkn` 作成＋`ghtkn auth`＝device flow）。トークン失効後も `mise run ghtkn:on` か `ghtkn auth` で復帰。戻すときは `mise run ghtkn:off`。

## パッケージ管理

- **mise 本体**: `bin/mise`（`mise generate bootstrap` 出力）で導入し、`mise self-update` で最新化。版数は renovate が `min_version` と埋込版を lockstep で追従（[更新](#更新)参照）
- **CLI ツール**: `mise/config.toml`の`[tools]`（aqua backend、checksum 検証あり）で宣言的に管理。renovate が追従
- **GUI アプリ**: 宣言的管理はせず手動導入（arc / claude / codex-app / ghostty。設定は dotfiles 管理）
- **フォント**: `mise/tasks/setup/font`（`mise run setup:font`）で Hack Nerd Font を `~/Library/Fonts` に導入
- **dotfiles**: `mise/config.toml`の`[dotfiles]`でシンボリックリンクを宣言的に管理（`mise dotfiles apply`で適用）
- **npm**: `mise/config.toml`の`NPM_CONFIG_REGISTRY`で既定レジストリを [Takumi Guard](https://shisho.dev/docs/t/guard/quickstart/)（悪意あるパッケージのブロックプロキシ）に設定
- **GitHub認証**: 既定は `gh auth login`、任意で `ghtkn`（GitHub App 短命トークン）に切替可

## 更新

- **mise 本体**: renovate が `min_version` と `bin/mise` の埋込版を lockstep で追従（minimum release age 付き、同じ depName なので1 PR で一括）。日常で最新にしたいときは `mise self-update`。`bin/mise` を綺麗に作り直したいときだけ手動再生成する: `mise generate bootstrap -w bin/mise`（checksum baseline も最新化される）
- **CLI ツール**: renovate の PR で `[tools]` と `mise.lock` を追従。手動なら `mise upgrade`
