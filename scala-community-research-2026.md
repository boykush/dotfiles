# Scala コミュニティ動向調査 (2025-2026)

2026年2月時点での Scala エコシステムの包括的な調査レポート。

---

## 1. Scala 3 の採用状況

### 数字で見る採用率

- **State of Scala 2025 調査**: Scala チームの92%以上が Scala 3 を部分的または完全に使用。約半数が本番環境への移行を完了
- **JetBrains 調査 (2025)**: 回答者446名中274名(59%)が Scala 3 を日常的に使用
- 2023年の調査では採用率が49%だったため、着実に成長している

### 移行の現実

- 「Scala 3 slowed us down?」というコミュニティブログ記事が話題になり、マクロ移行や `@inline` vs `inline` 等の動作差異が議論された
- 「2.13が EOL でないなら移行する理由は?」という疑問に対し、コンパイラ開発者は「大半のコードベースでは移行はかなりスムーズ」と反論
- Scala Center は ScalaFix ルールや `-source:3.0-migration` モード等の移行ツールを強化

### 企業での採用

- 金融（J.P. Morgan, Citi, Morgan Stanley, Barclays 等）、EC、データ分析がリード
- 金融セクターでの需要は「爆発的に増加」(Xebia)
- 平均年収は $146,000 で、最も高給なプログラミング言語の一つ

---

## 2. Scala 3 リリースロードマップ

### 現行 LTS: Scala 3.3.x

- 2023年5月リリース。Scala 初の Long-Term Support バージョン
- JDK 8 バイトコード対応を維持（レガシー互換性）

### Scala 3.8 (Scala Next) — 2025年Q4/2026年Q1 リリース済み

- **JDK 17 が最低要件**に（JEP 471 対応、JDK 25+ サポートのため）
- Scala 3 自身でコンパイルされた標準ライブラリを初搭載
- 安定化された機能:
  - Better Fors (SIP-62)
  - runtimeChecked (SIP-57)
- 実験的機能: flexible varargs, strict equality pattern matching
- 3.8.0 GA 後にランタイムリグレッションが発覚 → 3.8.1 で修正、3.8.2 は2026年2月下旬予定

### Scala 3.9 LTS — 2026年Q2 予定

- **次期 LTS ディストリビューション**（3.3 の後継）
- 3.8 以降のフィーチャーフリーズ（3.8 と比較して新機能なし）
- 一部のプレビュー機能が安定化される可能性
- Capture Checking（Rust ライクなメモリ安全性）の実験的機能が最終化される可能性
- JDK 17 ベースラインを引き継ぐ

### Scala 3.3 LTS のサポート終了

- 3.9 リリース後、最低1年間はサポート継続（〜2027年Q2まで）
- LTS ポリシー: 次の LTS リリースから最低1年間のパッチ保証

---

## 3. エコシステムとライブラリの動向

### 主要ライブラリの人気度推移

| ライブラリ | 2023年 | 2024年 | 2025年 | 傾向 |
|-----------|--------|--------|--------|------|
| Cats      | —      | —      | 安定   | 横ばい |
| ZIO       | —      | 27%    | 32%    | **上昇** |
| FS2       | —      | —      | 安定   | 横ばい |
| Akka      | 35%    | —      | 28%    | **下降** |
| Pekko     | 15%    | —      | 22%    | **上昇** |

### Akka → Pekko の移行

- **2022年9月**: Lightbend が Akka のライセンスを Apache 2.0 → Business Source License (BSL) 1.1 に変更
- 年間売上 $25M 超の企業は商用サブスクリプションが必要に
- **Apache Pekko**: Akka 2.6.20 のフォーク、Apache 2.0 ライセンスを維持
- 移行は比較的容易（パッケージ名 `akka.*` → `org.apache.pekko.*`、設定プレフィックス変更等）
- GetYourGuide の事例: 調査・コード変更に約2日、テスト・ロールアウトに約2日
- Akka Persistence のデータは Pekko Persistence と互換性あり

### Direct Style vs Monadic の議論

Scala コミュニティで最もホットな議論の一つ。Project Loom (Java 仮想スレッド) を契機に、従来の `IO` / `Task` ラッパーを使わない「Direct Style」プログラミングが注目を集めている。

#### Ox (SoftwareMill)

- Java 21 の仮想スレッドを活用した安全な direct-style 構造化並行処理
- Go ライクなチャンネルによるスレッド間通信
- **Ox 1.0** が Scala Days 2025 で発表
- JVM 専用（制限の一つ）

#### Kyo

- 代数的エフェクト (algebraic effects) ベースのアプローチ
- JVM / Scala Native / ScalaJS のマルチプラットフォーム対応
- 圏論の概念を前提としない直感的な API を目指す

#### 批判と課題

- Alexandru Nedelcu (2025年8月): Ox は JVM 専用で Scala Native/JS/Wasm をサポートしない制約がある
- Java 25 で Structured Concurrency が正式導入されれば、Ox の存在意義が薄れる可能性
- Scala が JVM に縛られすぎると、次世代 Java との差別化が困難になるという懸念

### Scala.js

- Scala.js 1.19.0: Wasm 出力が計算集約的なコードで JS より高速な場合も

### sbt 2.0

- RC フェーズ（2026年2月時点で RC8）、GA は未定
- Scala 3 を使用、ビルドクエリ、リモートキャッシュ等の新機能
- プラグイン作者が Scala 3 の機能を活用可能に

---

## 4. AI / LLM との統合

### LLM4S

- Scala 向けの GenAI ツールキット
- Scala Days 2025 で発表（「Scala Meets GenAI: Build the Cool Stuff with LLM4S」）
- Google Summer of Code プロジェクトとしても開発が進行
- 基本的な LLM 呼び出し、RAG 検索、画像処理、AI 駆動コード生成のデモ

### エンタープライズ AI

- Writer 社: Scala + FS2 + SSE でリアルタイム GenAI システムを構築、RAG で LLM を動的ビジネスデータに接地
- Spark, ZIO, Cats Effect 等の既存フレームワークが AI/ML ワークフローをサポート

### LLM 支援コーディング

- Scala Contributors で、Cursor や Copilot 等の LLM ツールが Scala 開発に与える影響についての議論が進行中

---

## 5. コミュニティの健全性

### カンファレンス

- **Scala Days 2025**: EPFL（Scala 発祥の地）で開催。約300名参加、20%が Scala 初心者
- **Scalar 2026**: 2026年3月26-27日にワルシャワで開催予定
- **Scala Days 2026**: 詳細は近日発表

### 人口規模

- Stack Overflow 2024 調査: 開発者の2.6%が Scala を使用
- 推定50万人以上のアクティブ開発者

### TIOBE Index での位置

- 2025年時点で **#27** (0.67%)
- メインストリームではないが、高価値ドメイン（金融、データエンジニアリング、分散システム）に深く根付いている

### 課題

- **採用の難しさ**: 43%のチームが経験豊富な Scala エンジニアの採用に苦労
- **競合言語**: Kotlin, Rust, Go, Java (改良版) との競争
- **複雑さの認識**: 「Scala is complex」というナラティブの払拭が課題

### ポジティブな兆候

- 新世代の実践者がコミュニティに参加（Scala Days 参加者の20%が新規）
- JetBrains が Scala Center の諮問委員会に参加 → IntelliJ Scala 3 サポートが大幅改善
- VirtusLab が Scala CLI, Metals 等のツール開発にコミット

---

## 6. Scala の戦略的方向性

### 公式見解

Scala チームは「Scala はメインストリーム言語と安定性・洗練度だけでは競争できない」とし、継続的な改善が必要と主張。フィーチャーフリーズは「停滞と失敗への確実な道」と位置づけている。

### ニッチ戦略

Scala Days 2025 での重要な洞察: **Scala の未来は広範な採用ではなく、型安全性・パフォーマンス・関数型パラダイムが測定可能なビジネス価値を提供する高度なユースケースでの「特化した卓越性」にある**。

### 注目すべき技術的方向

1. **Capture Checking**: Rust ライクなメモリ安全性をコンパイル時に保証
2. **Direct Style**: 仮想スレッドを活用した命令型スタイルの安全な並行処理
3. **マルチプラットフォーム**: Scala.js (Wasm 含む), Scala Native の成熟
4. **AI/ML 統合**: LLM4S, Spark 連携等

---

## 7. まとめ: 追えていなかった期間の主な変化

| 時期 | 出来事 |
|------|--------|
| 2022年9月 | Akka ライセンス変更 (Apache 2.0 → BSL 1.1) |
| 2023年5月 | Scala 3.3.0 LTS リリース（初の LTS） |
| 2023年 | Apache Pekko 1.0 リリース（Akka フォーク） |
| 2024-2025年 | Scala 3 採用率が49% → 59%+に成長 |
| 2025年 | Scala Days 2025 (EPFL)、Ox 1.0 発表 |
| 2025年Q4 | Scala 3.8 リリース（JDK 17 必須化） |
| 2025年 | sbt 2.0 RC、LLM4S 登場 |
| 2026年Q2 (予定) | Scala 3.9 LTS リリース |

---

### Sources

- [State of Scala 2025](https://scalac.io/state-of-scala-2025/)
- [State of Scala 2026](https://devnewsletter.com/p/state-of-scala-2026/)
- [Evolving Scala - scala-lang.org](https://www.scala-lang.org/blog/2025/03/24/evolving-scala.html)
- [IntelliJ Scala Plugin in 2025](https://blog.jetbrains.com/scala/2026/01/27/intellij-scala-plugin-in-2025/)
- [Scala 3.8 released](https://www.scala-lang.org/news/3.8/)
- [Next Scala 3 LTS series](https://www.scala-lang.org/blog/next-scala-lts.html)
- [Scala Days 2025 Recap](https://scalac.io/blog/scala-days-2025-recap-a-scala-community-reunion/)
- [Scala Days AI Integration](https://xebia.com/blog/scala-days-2025-ai-integration/)
- [Scala's Gamble with Direct Style](https://alexn.org/blog/2025/08/29/scala-gamble-with-direct-style/)
- [Scala Market Overview 2025](https://www.intsurfing.com/blog/scala-market-overview-2025/)
- [SoftwareMill - What to do with your End Of Life Akka?](https://softwaremill.com/what-to-do-with-your-end-of-life-akka/)
- [Ox GitHub](https://github.com/softwaremill/ox)
- [Kyo GitHub](https://github.com/getkyo/kyo)
- [Scala 3 Tech Survey by SoftwareMill](https://softwaremill.com/scala-3-tech-report/)
- [Scala Highlights June 2025](https://www.scala-lang.org/highlights/2025/06/26/highlights-june-2025.html)
- [LLM4S - Google Summer of Code](https://summerofcode.withgoogle.com/programs/2025/projects/DT8i5a1y)
- [Scalar Conference 2026](https://www.scalar-conf.com/)
