# AGENTS.md 用の文面（Claude Code 以外で常に ON にする場合）

Claude Code 以外のエージェント（Codex CLI など）では、フックで設定を自動的に注入できません。毎回スキルを呼び出さずに english-together を常に有効にしたい場合は、次の文面をプロジェクトの `AGENTS.md`、またはユーザー全体の AGENTS.md（Codex CLI なら `~/.codex/AGENTS.md`）に追記してください。

```markdown
## english-together

At the start of every conversation, use the `english-together` skill: run its
`scripts/config.sh show` to load the settings. If `enabled=true`, follow its
`references/rules.md` in every reply at the configured English ratio and
correction setting. If `enabled=false`, reply normally.
```

OFF に戻したいときは、「english-together を off にして」と伝えるか、`~/.config/english-together/config` の `enabled` を `false` にしてください。
