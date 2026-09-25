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
- 適用される dotfiles は `~/.zshrc` や `~/.config/*` など。mise 設定自身の `~/.config/mise` -> `~/dotfiles/mise` もここで張る。以降は新しい対話シェルで `.zshrc` の activate（`~/dotfiles/bin/mise` を絶対パス参照）が mise とツール群を使えるようにする。シェル初期化を経ないスクリプト等からは `~/dotfiles/bin/mise` を絶対パスで呼ぶ。
- `[bootstrap.repos]` を含むため `mise bootstrap` は管理対象リポジトリが clean であることを要求する（ローカル変更があると repos ステップで安全のため停止するので、コミット / stash してから実行する）。Claude Code が書き換える `~/.claude/settings.json` は copy で置いているので、アプリ側の設定変更では dirty にならない（取り込み方は[更新](#更新)）。

> 個別に実行したいときは `./bin/mise bootstrap dotfiles apply`（dotfiles のみ）／ `./bin/mise install`（tools のみ）／ `./bin/mise bootstrap packages apply`（GUI アプリ・フォントのみ）／ `./bin/mise bootstrap repos apply`（dotfiles リポジトリのみ）も使える。`mise bootstrap <part>` はサブコマンド必須なので `apply`（状況確認なら `status`）まで書く。なお `mise bootstrap` コマンドは、ラッパー `bin/mise` を生成する `mise generate bootstrap`（下記「更新」）とは別物。

### 3. GitHub 認証

`gh auth login` で認証する（git も gh も gh の保存トークンを利用。git の HTTPS 認証は `.gitconfig` の `gh auth git-credential` ヘルパー経由）。

## パッケージ管理

- **mise 本体**: `bin/mise`（`mise generate bootstrap` 出力）で導入し、`mise self-update` で最新化。版数は renovate が `min_version` と埋込版を lockstep で追従（[更新](#更新)参照）
- **CLI ツール**: `mise/config.toml`の`[tools]`（aqua backend。版数を pin し、aqua registry の checksum で検証）で宣言的に管理。renovate が追従
- **GUI アプリ**: `mise/config.toml`の`[bootstrap.packages]`（brew-cask backend）で宣言的に管理。`mise bootstrap`で`/Applications`へ導入（mise 組み込みのインストーラーが Homebrew cask API から直接取得するため brew バイナリは不要）
- **フォント**: `mise/config.toml`の`[bootstrap.packages]`（`brew-cask:font-hack-nerd-font`）で Hack Nerd Font を `~/Library/Fonts` に導入（GUI アプリと同じ brew-cask backend）
- **dotfiles**: `mise/config.toml`の`[dotfiles]`でシンボリックリンク（設定ファイル。アプリ自身が書き換える `~/.claude/settings.json` だけは copy）とファイル内ブロック編集（`~/.zshrc` のシェル初期化）を宣言的に管理（`mise bootstrap`で適用。`mise bootstrap dotfiles apply`で個別適用も可）
- **npm**: `mise/config.toml`の`NPM_CONFIG_REGISTRY`で既定レジストリを [Takumi Guard](https://shisho.dev/docs/t/guard/quickstart/)（悪意あるパッケージのブロックプロキシ）に設定
- **GitHub認証**: `gh auth login`（gh は保存トークン、git は `.gitconfig` の `gh auth git-credential` ヘルパー経由で認証）

## AI エージェントへの配布物

リポジトリ横断で使う MCP サーバーとスキルは apm package として配る。dotfiles が持つのは「このマシンの user scope へ何を展開するか」の宣言（`apm/apm.yml`）だけで、Claude Code と Codex の両方へ同じ宣言から展開する。

### MCP サーバー

サーバーの定義は [boykush/ai-plugins](https://github.com/boykush/ai-plugins) が apm package として配る。**サーバー名も URL もそちらの package が持つ**ので、ここには写さない。

**global に載せるのは wiki だけ**。wiki は [agents/AGENTS.md](agents/AGENTS.md) がセッションを問わず引かせる1次ソースで、リポジトリの外で始めたセッションからも引ける必要がある。

[boykush/adr](https://github.com/boykush/adr) は `boykush` 配下のリポジトリに横断する決定の置き場で、適用範囲も `boykush` 配下と明記している。一方 dotfiles はこのマシンの全セッションに効き、`boykush` 配下以外のリポジトリにも及ぶので、adr を扱うときは**範囲外へ決定を持ち込まないよう注意する**。global に載せていないのはこのためで、`adr` は必要なリポジトリが自分の `apm.yml` で宣言する。

### プラグイン

外から来る plugin は apm だけで宣言し、Claude Code の `enabledPlugins`（[claude-code/settings.json](claude-code/settings.json)）には書かない。あれは Claude Code にしか効かず、入っている版もアプリの runtime しか知らないので、宣言からは何が効いているか分からない。

展開先は skill が `~/.claude/skills/<name>` と `~/.agents/skills/<name>`（Codex の user scope は `$HOME/.agents/skills`）、command が `~/.claude/commands/<name>.md`。**command は Codex へ届かない**（apm から見て Claude Code は skill も command も native だが、Codex は skill だけ）。

Codex にも同じ plugin を marketplace から入れる口が `~/.codex/config.toml` にあり、**このファイルは dotfiles の管理外**なので、apm で配るものは向こうで無効化する。二重に有効だと同じ `~/.agents/skills/<name>` をプラグインと apm が取り合う。

クライアントが自分で同梱するものは宣言しない。Claude Code はバイナリに `anthropic-skills`（docx / pdf / pptx / xlsx / claude-api ほか）を、Codex は `~/.codex/skills/.system`（skill-creator / skill-installer / plugin-creator / openai-docs / imagegen）を持つ。Codex では system の `skill-creator` と apm の `skill-creator` が同名で並ぶが、Codex は同名を統合せず両方見せる仕様で、プラグイン経由だった移行前と同じ状態になる。

### 適用

```bash
mise run apm:apply
```

`apm install -g` が走り、MCP サーバーは Claude Code が `~/.claude.json`・Codex が `~/.codex/config.toml`、skill は `~/.claude/skills` と `~/.agents/skills`、command は `~/.claude/commands` に入る。どれもアプリ状態なので dotfiles では管理せず、apm に書かせる。`~/.apm/apm.lock.yaml` も同様にマシン側に残す（symlink 越しでも apm が書けることは確認済みなので、pin をマシン間で共有したくなったら `[dotfiles]` に足せる）。

`~/.apm` 自体を symlink にすると apm が `Refusing symlinked lifecycle lock path` で起動を拒否するため、張るのは `~/.apm/apm.yml` だけ。

依存は SHA で pin する。ref を省くと apm が `1 dependency unpinned` と警告し、`#main` では Renovate に上げる値が無い。main の HEAD への追従は [renovate-runner](https://github.com/boykush/renovate-runner) の `config.js` にあるグローバルな customManager（`github-digest` datasource）が digest 更新として運ぶ。第三者の package には commit date が releaseTimestamp として付くので、グローバルの `minimumReleaseAge` がそのまま効く。PR がマージされても手元の展開は動かないので、`mise run apm:apply` を回して初めて新しい commit の定義になる。

### project scope との関係

リポジトリ側が自分の `apm.yml` で package を宣言すれば、`apm install` が project scope の `.mcp.json`（Claude Code）と `.codex/config.toml`（Codex）を生成する。同名サーバーが両方にあるときは **cwd に近い project scope が勝つ**ので、wiki を宣言したリポジトリでは package 側の定義が効き、global の写しが古くても shadow はしない。

project scope の `.mcp.json` 由来のサーバーは repo ごとに承認プロンプトが出る。`claude-code/settings.json` の `enabledMcpjsonServers` で事前承認しているのは `scraps` だけなので、`adr` を宣言したリポジトリでは初回に1度承認する（`enableAllProjectMcpServers` は clone してきた repo の `.mcp.json` まで無条件に通すので使わない）。事前承認はサーバー名でのマッチなので、増やすほど clone してきた repo の同名・別 URL を通す口が広がる。

### remote サーバーの実体

`scraps` は wiki の内容を焼いた image、`adr` は決定を焼いた image で、どちらも各アプリ repo の CI が GHCR へ push し、manifest は [boykush/infrastructure-as-code](https://github.com/boykush/infrastructure-as-code) が持つ。したがって MCP から引ける内容は **main に push 済みのもの**で、手元の未 push な編集は含まれない。

ローカルで scraps を動かす経路は持たない。stdio サーバーの task、それに読ませる wiki の複製（`~/dotfiles/wiki`）、`[tools]` の scraps 本体を置かず、参照先を remote に保つ。繋がらないときは公開サイト <https://boykush.github.io/wiki/> を見る。

エージェントがいつ wiki を引くかは [agents/AGENTS.md](agents/AGENTS.md) の「私のナレッジ（Scraps wiki）を引く」に書いてある。

## 更新

- **mise 本体**: renovate が `min_version` と `bin/mise` の埋込版を lockstep で追従（minimum release age 付き、同じ depName なので1 PR で一括）。日常で最新にしたいときは `mise self-update`。`bin/mise` を綺麗に作り直したいときだけ手動再生成する: `mise generate bootstrap -w bin/mise`（checksum baseline も最新化される）
- **CLI ツール**: renovate の PR で `[tools]` の版数を追従（lockfile は使わないので PR は config.toml の1行差分だけ）。手動なら `mise upgrade`
- **管理対象リポジトリ**: `mise bootstrap` の repos ステップが `~/dotfiles` を `main` へ追従。毎回 `git ls-remote` でローカル HEAD と origin/main を照合し、差分があれば `git fetch` → `checkout main` → `pull --ff-only` で更新する（dirty なら適用前に停止。push 前のローカル commit で diverge していても ff-only が失敗するだけで履歴は書き換えない）
- **アプリが書き換える設定**: `~/.claude/settings.json` は copy なので、Claude Code（CLI / デスクトップアプリ）での設定変更はマシン側のファイルにだけ入り、次の `mise bootstrap` で宣言内容に戻る。`./bin/mise bootstrap status --missing` がこのファイルを `differs` と報告したら `./bin/mise bootstrap dotfiles diff ~/.claude/settings.json` で中身を確認し、残す変更は `./bin/mise bootstrap dotfiles add ~/.claude/settings.json` でソースに取り込んでコミットする

### main の変更が反映されるまで

各マシンは `./bin/mise bootstrap` の再実行で main に収束する。bootstrap は dotfiles ステップ直後に config をディスクから再読込するため、repos ステップが pull した変更のうち **symlink 先・copy 元ファイルの中身・`[bootstrap.macos.defaults]`・`[tools]` は同じ run で反映**される。一方、再読込より前に評価される **`[bootstrap.packages]` と `[dotfiles]` のエントリ増減・block 本文は次の run 送り**になる。これらを含む変更を取り込むときは bootstrap を続けて2回流すか、先に `git pull` してから流す（checkout が既に main 先端なら lag は出ない）。収束の機械確認は `./bin/mise bootstrap status --missing`（CI と同じ検証）。

`min_version` の bump（renovate が `bin/mise` 埋込版と lockstep で追従）を bootstrap 自身の pull で取り込んだ回は、config 再読込時の min_version チェックで一度停止するが、次回は pull 済みの新 `bin/mise` が新しい mise を self-install して通る（自己修復）。
