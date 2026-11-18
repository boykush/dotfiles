# doc-refactor

文書をコードと同じようにリファクタリングする skill を配る plugin。[Agent Plugins](https://agent-plugins.org/specification) の形で書く。MCP サーバーは配らず、skill `doc-refactor`（`skills/doc-refactor/`）だけを配る。

dotfiles に置くのは、この skill を直す理由が、文書の扱い方についての自分の方針——[agents/AGENTS.md](../../agents/AGENTS.md) がこの skill に従うよう名指ししている——と同じところで生まれるため。

## 何をする skill か

事実を機械が読める1つの持ち主（宣言・設定・スキーマ・カタログの entity と edge）へ**移し**、散文をその**参照に置き換える**。コードのリファクタリングと同じく、意味を変えずに動かすのが条件で、移す前に移した先がその事実を持っているかを確かめる。

目標は機械化で、写しが減るのは結果。散文を綺麗にするのではなく、持ち主を作って散文を減らす方向に効く。

実際に起きた drift を1週間分追うと、修正はほぼすべて「他のファイルが既に持っている事実の写し」だった。共通点は2つで、どちらも書き方ではなく置き場の問題だった。

- 機械可読な持ち主（変数・宣言・検索条件）があるのに、散文が一覧や件数を写していた
- 同じ契約が2つのリポジトリの散文に両方あり、互いに「相手が持っている」と書いていた

renderer を変えても直らない種類の問題なので、この skill が持つのは移す順番と、写しの見つけ方だけ。**公開して人に使わせる repo は対象外**で、それぞれが独立して文書の戦略を持つ。

## 規範と手順を分ける

**基準はこの skill が持ち、AGENTS.md には「文書を書くとき・消すときはこの skill に従う」だけを置く。** AGENTS.md は毎セッション context に載る push の面なので短くなければならず、基準そのものを両方に書けばそれ自体が写しになる。呼ばれたときだけ読まれる skill 側は、手順まで持てる。

command ではなく skill にしてあるのは、apm から見て command が Codex へ届かないため。

## 使う

リポジトリの `apm.yml`:

```yaml
dependencies:
  apm:
    - boykush/dotfiles/plugins/doc-refactor#<SHA> # doc-refactor--v<version>
```

```bash
apm install
```

Claude は `.claude/skills/`、Codex は `.agents/skills/` に入る。マシンの全セッション（リポジトリの外や `boykush` 配下以外も含む）に効かせるなら、この repo の [apm/apm.yml](../../apm/apm.yml)（user scope）で宣言する。基準にリポジトリ固有の話は入れていないので、どちらでも効く。

隣の `apm.yml` は、apm がこの plugin を Claude と Codex へ展開するための中継ぎで、[boykush/workflows](https://github.com/boykush/workflows) の agent-plugins が `plugin.json` から書く。手では直さない。版は `plugin.json` の `version` が持ち、main に入ると同じ workflow が `doc-refactor--v<version>` の tag を打つ。consumer の Renovate はこの tag を追う。
