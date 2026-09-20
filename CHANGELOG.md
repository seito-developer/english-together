# Changelog

## [0.2.0] - 2026-09-20

### Added

- `direction` 設定：`ja2en`（英語を学ぶ日本語話者、既定）に加えて `en2ja`（日本語を学ぶ英語話者）に対応。`ratio` は「学習する言語の割合」を意味するように統一
- `en2ja` の段階表と読みの補助（比率 30% 以下では、初出の日本語にローマ字と英語の意味を添える）
- `adaptive` 設定（既定 ON）：「日本語で言って」などの明示の言及で 10% 下げ、下げる操作のないセッションが 3 回続くと次回の起動時に 10% 上げる
- `/english-together direction ja2en|en2ja` と `/english-together adaptive on|off`

### Changed

- ルールを `rules-core.md` と方向別の段階表に分割し、フックは使用中の方向の分だけを注入するようにした
- フックの注入文に `config.sh` の実パスを含めるようにした（設定ファイルが直接書き換えられて設定を失うのを防ぐため）
- `SessionStart` を `startup` とそれ以外（`resume`／`clear`／`compact`）に分け、自動調整のカウントは `startup` のときだけ行うようにした

## [0.1.0] - 2026-09-11

### Added

- `english-together` スキル：英語の割合（0〜100%、10% 刻み）に応じて、日本語の応答に英語を混ぜる
- 日英が混在した指示の解釈と、ユーザーの英語へのさりげない添削（`correct on|off`）
- `/english-together` コマンド：`<割合>`、`on`、`off`、`correct on|off`、`status`
- `~/.config/english-together/config` による設定の永続化（`config.sh`）
- Claude Code フック：SessionStart（compaction のあとを含む）でのルール注入と、UserPromptSubmit での1行リマインダー
- Claude Code マーケットプレイスへの対応と、`npx skills add` での他のエージェントへのインストール
