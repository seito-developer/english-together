# Changelog

## [0.1.0] - 2026-09-11

### Added

- `english-together` スキル：英語の割合（0〜100%、10% 刻み）に応じて、日本語の応答に英語を混ぜる
- 日英が混在した指示の解釈と、ユーザーの英語へのさりげない添削（`correct on|off`）
- `/english-together` コマンド：`<割合>`、`on`、`off`、`correct on|off`、`status`
- `~/.config/english-together/config` による設定の永続化（`config.sh`）
- Claude Code フック：SessionStart（compaction のあとを含む）でのルール注入と、UserPromptSubmit での1行リマインダー
- Claude Code マーケットプレイスへの対応と、`npx skills add` での他のエージェントへのインストール
