# dotfiles

miseを中心とした開発環境の設定ファイル群です。

## セットアップ

新環境に mise を事前インストールする必要はない。リポジトリ同梱の `bin/mise`（`mise generate bootstrap` の出力＝自己インストールラッパー）が mise 本体を取得して実行する。

### 1. リポジトリ取得

```bash
git clone git@github.com:boykush/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. マシンのセットアップ（GUI アプリ・フォント + CLI ツール + dotfiles を一括）

```bash
./bin/mise bootstrap
```

`mise bootstrap` は現行 config に対して宣言的なセットアップを順に流す1コマンドで、この repo では **`[bootstrap.packages]` の GUI アプリ・フォント（brew-cask。アプリは `/Applications`、フォントは `~/Library/Fonts`）**・**`[bootstrap.repos]` の dotfiles リポジトリ自身（`~/dotfiles` を `main` に追従）**・**`[tools]` の CLI ツール**・**`[dotfiles]` のシンボリックリンク／ファイル内ブロック編集**を一括適用する（他の `[bootstrap.*]` は未定義なので no-op）。宣言的ステップは収束するため再実行は安全で、状況は `./bin/mise bootstrap status` で確認できる。

- `bin/mise` は初回に mise 本体を `~/.cache/mise` へ取得してから実行する（mise 未導入でも動く）。リポジトリ内で実行するため `mise/config.toml` がローカル config として読まれる。埋込版は renovate が `min_version` と lockstep で追従するため floor を下回らない（任意で最新化するなら `./bin/mise self-update`）。
- 適用される dotfiles は `~/.zshrc` や `~/.config/*` など。mise 設定自身の `~/.config/mise` -> `~/dotfiles/mise` もここで張る。以降は新しいシェルで `~/dotfiles/bin` が PATH に入り、`mise` はこのラッパーに解決される。
- `[bootstrap.repos]` を含むため `mise bootstrap` は `~/dotfiles` が clean であることを要求する（ローカル変更があると repos ステップで安全のため停止するので、コミット / stash してから実行する）。

> 個別に実行したいときは `./bin/mise dotfiles apply`（dotfiles のみ）／ `./bin/mise install`（tools のみ）／ `./bin/mise bootstrap packages`（GUI アプリ・フォントのみ）／ `./bin/mise bootstrap repos`（dotfiles リポジトリのみ）も使える。なお `mise bootstrap` コマンドは、ラッパー `bin/mise` を生成する `mise generate bootstrap`（下記「更新」）とは別物。

### 3. GitHub 認証

既定は `gh auth login`。ghtkn を使わない環境は `gh auth login` するだけ（git も gh も gh の保存トークンを利用）。

GitHub App の短命トークン（8時間／[ghtkn](https://github.com/suzuki-shunsuke/ghtkn)）を使う環境は:

1. device flow を有効にした GitHub App を用意し、Client ID を `ghtkn/ghtkn.yaml` に記入（機密ではないためコミット可）。
2. `mise run ghtkn:on` で切り替え（`~/.gitconfig.ghtkn` 作成＋`ghtkn auth`＝device flow）。トークン失効後も `mise run ghtkn:on` か `ghtkn auth` で復帰。戻すときは `mise run ghtkn:off`。

## パッケージ管理

- **mise 本体**: `bin/mise`（`mise generate bootstrap` 出力）で導入し、`mise self-update` で最新化。版数は renovate が `min_version` と埋込版を lockstep で追従（[更新](#更新)参照）
- **CLI ツール**: `mise/config.toml`の`[tools]`（aqua backend、checksum 検証あり）で宣言的に管理。renovate が追従
- **GUI アプリ**: `mise/config.toml`の`[bootstrap.packages]`（brew-cask backend）で宣言的に管理。`mise bootstrap`で`/Applications`へ導入（brew バイナリが前提）
- **フォント**: `mise/config.toml`の`[bootstrap.packages]`（`brew-cask:font-hack-nerd-font`）で Hack Nerd Font を `~/Library/Fonts` に導入（GUI アプリと同じ brew-cask backend）
- **dotfiles**: `mise/config.toml`の`[dotfiles]`でシンボリックリンク（設定ファイル）とファイル内ブロック編集（`~/.zshrc`/`~/.zshenv` のシェル初期化）を宣言的に管理（`mise bootstrap`で適用。`mise dotfiles apply`で個別適用も可）
- **npm**: `mise/config.toml`の`NPM_CONFIG_REGISTRY`で既定レジストリを [Takumi Guard](https://shisho.dev/docs/t/guard/quickstart/)（悪意あるパッケージのブロックプロキシ）に設定
- **GitHub認証**: 既定は `gh auth login`、任意で `ghtkn`（GitHub App 短命トークン）に切替可

## 更新

- **mise 本体**: renovate が `min_version` と `bin/mise` の埋込版を lockstep で追従（minimum release age 付き、同じ depName なので1 PR で一括）。日常で最新にしたいときは `mise self-update`。`bin/mise` を綺麗に作り直したいときだけ手動再生成する: `mise generate bootstrap -w bin/mise`（checksum baseline も最新化される）
- **CLI ツール**: renovate の PR で `[tools]` と `mise.lock` を追従。手動なら `mise upgrade`
- **dotfiles リポジトリ**: `mise bootstrap` の repos ステップが `~/dotfiles` を `main` へ追従（clean な作業ツリー時のみ。dirty なら停止）
