# english-together

> トゥギャザーしようぜ！

AI との対話を「日本語と英語のちゃんぽん」にして、英語学習の認知負荷を下げる **Claude Code プラグイン／Agent Skill** です。

[English README](README.en.md)

100% 英語で AI とやり取りするのは、疲れて続きません。english-together を使うと、AI の応答に **設定した割合（0〜100%）の英語** が混ざります。普段の開発や調べものをしながら、無理なく英語に触れ続けられます。

- **応答のミックス**：英語の割合を 10% 刻みで設定できます。割合が低いうちは単語単位、上がるにつれてフレーズ単位、文単位へと自動で変わります
- **混在入力の解釈**：「この function の bug を fix して」のような日英混じりの指示も、そのまま理解して作業します
- **さりげない添削**：あなたの英語に不自然なところがあれば、応答の最後に 💡 English tip を1〜2行で添えます（OFF にもできます）
- **大事なところは混ぜない**：コード、コマンド、コミットメッセージ、生成したドキュメント、重要な警告は、ミックスせずに通常どおり書きます

## 例

質問：「HTTP の GET と POST の違いを教えて」

| 英語の割合 | 応答の例 |
|---|---|
| 20% | GET は data を取得するための method で、parameter は URL に付きます。 |
| 50% | GET は data を取得するための method で、parameters go in the URL, so URL に丸見えになります。 |
| 80% | GET retrieves（取得する）data from the server. Parameters go in the URL, so they show up in the browser history. |
| 100% | GET retrieves data from the server. Parameters go in the URL, so they show up in the browser history. |

添削の例：

```
💡 English tip: "Please explain me about what is the docker compose" → "Please explain to me what Docker Compose is."（explain は「explain to 人」の形になります）
```

## インストール

### Claude Code（推奨）

Claude Code の中で次のコマンドを実行します。

```
/plugin marketplace add seito-developer/english-together
/plugin install english-together@english-together
```

インストール直後は OFF になっています。`/english-together` で有効にしてください。

### 他のエージェント（Codex CLI、Cursor、GitHub Copilot など）

[skills CLI](https://github.com/vercel-labs/skills) を使うと、Agent Skills に対応した各種エージェントにインストールできます。

```sh
npx skills add seito-developer/english-together
```

手動で入れる場合は、`skills/english-together/` ディレクトリを、使っているエージェントのスキル用ディレクトリ（例：`~/.agents/skills/`）にコピーしてください。

Claude Code 以外ではフックが使えないため、会話ごとに「english-together で英語30%で話して」のように呼び出してください。毎回呼び出さずに常に有効にしたい場合は、[AGENTS.md 用の文面](docs/agents-md-snippet.md) をプロジェクトまたはユーザーの AGENTS.md に追記してください。

## 使い方

| コマンド | 動作 |
|---|---|
| `/english-together` | 現在の設定で ON にする |
| `/english-together 30` | 英語の割合を 30% にして ON にする（10% 刻み。35 は 40 に丸める） |
| `/english-together off` | OFF にする |
| `/english-together on` | ON にする |
| `/english-together correct off` | 添削をやめる（`correct on` で再開） |
| `/english-together status` | 現在の設定を表示する |

コマンドの代わりに、「英語30%で話して」「英語多めにして」「添削はいらない」のように話しかけても設定を変えられます。

> 他のプラグインに同じ名前のコマンドがある場合は、正式名の `/english-together:english-together` を使ってください。

## 設定

設定は `~/.config/english-together/config` に保存され、次のセッション以降も引き継がれます。どのエージェントからも同じファイルを参照します。

```
enabled=false     # true にすると、どの会話でも常に ON
ratio=20          # 英語の割合（0〜100、10 刻み）
correction=on     # 添削の有無（on / off）
```

置き場所は、環境変数 `ENGLISH_TOGETHER_CONFIG` で変えられます。

## ミックスしないもの

- コードブロック、インラインコード、コマンド、ファイルパス、URL、エラーメッセージ
- ファイルや外部に残るもの：コミットメッセージ、コードコメント、生成したドキュメント、PR や Issue の本文
- 重要な警告や確認（破壊的な操作、セキュリティ、データの消失など）：誤解を防ぐため、日本語で書きます

## 仕組み

```
skills/english-together/
├── SKILL.md              # コマンドと設定変更の手順
├── references/rules.md   # 混ぜ方のルール（割合ごとの定義と例）
└── scripts/config.sh     # 設定ファイルの読み書き（POSIX sh）
hooks/
├── hooks.json            # SessionStart / UserPromptSubmit フック
└── inject.sh             # ON のときだけルールと設定を注入
```

Claude Code では、セッションの開始時と compaction（コンテキストの自動要約）のあとにルールを注入し、毎回のメッセージに1行のリマインダーを付けます。これで、長い会話でも割合がブレにくくなります。OFF のときは何も注入しないので、トークンを消費しません。

## アンインストール

```
/plugin uninstall english-together@english-together
```

設定ファイルも消す場合は、`~/.config/english-together/` を削除してください。

## 開発

```sh
sh tests/test_config.sh && sh tests/test_inject.sh   # 単体テスト
claude plugin validate . --strict                    # マニフェストの検証
claude --plugin-dir .                                # ローカルで試す
```

設計の詳細は [設計スペック](docs/superpowers/specs/2026-09-11-english-together-design.md) を参照してください。

## 名前の由来

ルー大柴さんの「トゥギャザーしようぜ！」から。日本語と英語を混ぜて話すスタイルを、学習の味方にしようというプロジェクトです。

## ライセンス

[MIT](LICENSE)
