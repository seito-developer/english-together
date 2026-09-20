# english-together

You can see the README in English here.  
[English README](README.en.md)

「AIとの会話を普段から英語で行うようにすれば英語学習になるのでは？」

そう思って、AIとの会話を英語でやってみよう！と思ったことはないでしょうか？

だけど実際にやってみると、
「１００％英語でのやり取りだと読むのがしんどい」
「全部英語化するのは時間がかかって疲れる」
そんな状態に、2、3日で陥ります。

では5:5くらいなら？
あるいは3:7で日本語・英語を使うなら？

それだったら続けられるんじゃないか...そんなアイデアからこのスキルは生まれました。

これは、AIとの対話において、「日本語と英語を混ぜて行うこと」ことで英語学習の認知負荷を下げる **AIエージェント向けプラグイン／Agent Skill** です。（Claude CodeやCodexに対応）
スキル名の「English Together」は、日本語と英語をごちゃまぜで話すのが芸風の日本のタレント「ルー大柴さん」の代名詞「トゥギャザーしようぜ！」からインスパイアされています。

https://github.com/user-attachments/assets/bdc3ffd4-977a-46ce-a4cc-a149e864c392

100% 英語で AI とやり取りするのは、疲れて続きません。english-together を使うと、AI の応答に **設定した割合（0〜100%）の英語** が混ざります。普段の開発や調べものをしながら、無理なく英語に触れ続けられます。

- **応答のミックス**：英語の割合を 10% 刻みで設定できます。割合が低いうちは単語単位、上がるにつれてフレーズ単位、文単位へと自動で変わります
- **混在入力の解釈**：「この function の bug を fix して」のような日英混じりの指示も、そのまま理解して作業します
- **さりげない添削**：あなたの英語に不自然なところがあれば、応答の最後に 💡 English tip を1〜2行で添えます（OFF にもできます）
- **比率の自動調整**：「日本語で言って」と伝えれば下がり、順調なセッションが続けば少しずつ上がります（OFF にもできます）
- **逆方向にも対応**：日本語を学ぶ英語話者向けに、英語の文に日本語を混ぜるモード（`en2ja`）もあります
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

## インストール方法（3つあります）

入るスキルの中身はどれも同じです。違うのは **どのエージェントに入るか** と、**フックが付くかどうか** の2点です。

| | 方法 | 対応するエージェント | フック |
|---|---|---|---|
| **方法1** | Claude Code のプラグインとして入れる | Claude Code | あり |
| **方法2** | skills CLI で入れる | Codex CLI、Cursor、GitHub Copilot など、Agent Skills に対応したエージェント | なし |
| **方法3** | 手動でコピーする | 同上 | なし |

フックが無い場合、**比率が自動で上がる機能だけ**が働きません（セッションの開始時に数える仕組みのため）。下げる方も、手動での変更も、混ぜ方そのものも同じように使えます。

Claude Code で使うなら **方法1** をおすすめします。

### 方法1：Claude Code のプラグインとして入れる

Claude Code を開き、入力欄に次のコマンドを1つずつ入力して Enter を押します。

**手順 1：配布元を登録する**

```
/plugin marketplace add seito-developer/english-together
```

english-together の配布元（GitHub 上のこのリポジトリ）を Claude Code に登録します。アプリストアを追加するようなものです。

**手順 2：インストールする**

```
/plugin install english-together@english-together
```

登録した配布元から english-together をインストールします。`@` の前はプラグイン名、後ろは配布元の名前です（どちらも english-together です）。

**手順 3：有効にする**

```
/english-together
```

インストール直後は OFF になっているので、このコマンドで ON にします。

### 方法2：skills CLI で入れる（Claude Code 以外のエージェント）

[skills CLI](https://github.com/vercel-labs/skills) を使うと、Agent Skills に対応した各種エージェントにインストールできます。

```sh
npx skills add seito-developer/english-together
```

対話形式で、どのエージェントに入れるかを選べます。

### 方法3：手動でコピーする

リポジトリを取得して、`skills/english-together/` を、使っているエージェントのスキル用ディレクトリにコピーします。

```sh
git clone https://github.com/seito-developer/english-together.git
cp -r english-together/skills/english-together ~/.agents/skills/
```

置き場所はエージェントによって変わります（例：`~/.agents/skills/`、`~/.claude/skills/`、プロジェクト直下の `.agents/skills/`）。

### 方法2・方法3のあとに

フックが無いため、会話ごとに「english-together で英語30%で話して」のように呼び出してください。毎回呼び出さずに常に有効にしたい場合は、[AGENTS.md 用の文面](docs/agents-md-snippet.md) をプロジェクトまたはユーザーの AGENTS.md に追記してください。

## 使い方

| コマンド | 動作 |
|---|---|
| `/english-together` | 現在の設定で ON にする |
| `/english-together 30` | 英語の割合を 30% にして ON にする（10% 刻み。35 は 40 に丸める） |
| `/english-together off` | OFF にする |
| `/english-together on` | ON にする |
| `/english-together correct off` | 添削をやめる（`correct on` で再開） |
| `/english-together adaptive off` | 比率の自動調整をやめる（`adaptive on` で再開） |
| `/english-together direction en2ja` | 方向を切り替える（`ja2en` で戻す。下の「2つの方向」を参照） |
| `/english-together status` | 現在の設定を表示する |

コマンドの代わりに、「英語30%で話して」「英語多めにして」「添削はいらない」のように話しかけても設定を変えられます。

> 他のプラグインに同じ名前のコマンドがある場合は、正式名の `/english-together:english-together` を使ってください。

## 比率の自動調整

自分にちょうどいい比率は、自分では分かりにくいものです。english-together は、あなたの反応を見て比率を上げ下げします（初期値は ON）。

- **下がるとき**：「日本語で言って」「もう一回」「意味が分からない」のように、**はっきり伝えたとき** だけ 10% 下がります。その場で言い直し、いまの比率を1行で知らせます。
- **上がるとき**：下げる操作が一度もなかったセッションが **3回続くと**、次に Claude Code を起動したときに 10% 上がります。会話の途中で突然変わることはありません。
- 「X ってどういう意味？」と聞くのは学習のための質問なので、比率は下がりません。下げたいときは、はっきり「日本語で言って」と伝えてください。
- 自動調整を止めたいときは `/english-together adaptive off` です。上げ下げはすべて手動になります。

Claude Code 以外のエージェントではフックが動かないため、**上がる方（セッション単位の判定）は働きません**。下がる方と手動での変更は同じように使えます。

## 2つの方向

`direction` で、どちらの言語を学ぶかを切り替えられます。`ratio` は常に **学習する言語の割合** を意味します。

| 設定 | 使う人 | 応答のベース | 混ざる言語 |
|---|---|---|---|
| `ja2en`（初期値） | 英語を学ぶ日本語話者 | 日本語 | 英語 |
| `en2ja` | 日本語を学ぶ英語話者 | 英語 | 日本語 |

```
/english-together direction en2ja
/english-together 30
```

`en2ja` の応答例（日本語 30%）：

> A **reverse proxy** is a サーバー (sābā — server) that sits **in front of** your real servers.

日本語の文字はいちばんの壁なので、比率が 30% 以下のあいだは、初めて出てくる語にローマ字と英語の意味を添えます。40% を超えると、難しい語だけに絞っていきます。添削も方向に合わせて切り替わり、`en2ja` では英語話者の日本語に 💡 日本語 tip が付きます。

## 設定

設定は `~/.config/english-together/config` に保存され、次のセッション以降も引き継がれます。どのエージェントからも同じファイルを参照します。

```
enabled=false       # true にすると、どの会話でも常に ON
ratio=20            # 学習する言語の割合（0〜100、10 刻み）
correction=on       # 添削の有無（on / off）
direction=ja2en     # ja2en：英語を学ぶ / en2ja：日本語を学ぶ
adaptive=on         # 比率の自動調整（on / off）
smooth_sessions=0   # 自動調整の内部カウンタ（手で書き換えないでください）
```

置き場所は、環境変数 `ENGLISH_TOGETHER_CONFIG` で変えられます。

## ミックスしないもの

- コードブロック、インラインコード、コマンド、ファイルパス、URL、エラーメッセージ
- ファイルや外部に残るもの：コミットメッセージ、コードコメント、生成したドキュメント、PR や Issue の本文
- 重要な警告や確認（破壊的な操作、セキュリティ、データの消失など）：誤解を防ぐため、日本語で書きます

## 仕組み

```
skills/english-together/
├── SKILL.md                        # コマンドと設定変更の手順
├── references/rules-core.md        # 方向に依存しない共通ルール
├── references/levels-ja2en.md      # 英語を学ぶ場合の段階表
├── references/levels-en2ja.md      # 日本語を学ぶ場合の段階表
└── scripts/config.sh               # 設定ファイルの読み書き（POSIX sh）
hooks/
├── hooks.json                      # SessionStart / UserPromptSubmit フック
└── inject.sh                       # ON のときだけルールと設定を注入
```

Claude Code では、セッションの開始時と compaction（コンテキストの自動要約）のあとにルールを注入し、毎回のメッセージに1行のリマインダーを付けます。これで、長い会話でも割合がブレにくくなります。注入するのは共通ルールと **いま使っている方向の段階表だけ** です。OFF のときは何も注入しないので、トークンを消費しません。

比率を上げる判定はフックが行います（セッションの開始時に数えるだけ）。下げる判定はモデルが行い、実際の書き換えは `config.sh` が担当するので、設定ファイルが壊れることはありません。

## アンインストール

方法1（プラグイン）で入れた場合：

```
/plugin uninstall english-together@english-together
```

方法2（skills CLI）で入れた場合は `npx skills remove english-together`、方法3（手動コピー）で入れた場合はコピーしたディレクトリを削除してください。

設定ファイルも消す場合は、`~/.config/english-together/` を削除してください。

## 開発

```sh
sh tests/test_config.sh && sh tests/test_inject.sh   # 単体テスト
claude plugin validate . --strict                    # マニフェストの検証
claude --plugin-dir .                                # ローカルで試す
```

## ライセンス

[MIT](LICENSE)
