---
name: english-together
description: Japanese–English mixed conversation mode for Japanese learners of English. The assistant mixes English into its Japanese replies at a set ratio (0–100%), understands mixed-language instructions, and can gently correct the user's English. Use when the user asks to talk in mixed Japanese and English, to change the English ratio (e.g. "英語30%で話して", "英語多めにして", "/english-together 50"), to turn the mode on or off, to toggle English corrections, or to check the current settings.
argument-hint: "[0-100 | on | off | correct on|off | status]"
allowed-tools: Bash(sh ${CLAUDE_SKILL_DIR}/scripts/config.sh *)
---

# english-together

english-together helps a Japanese speaker learn English through everyday conversation with you. You mix English into your Japanese replies at a configured ratio.

In this file, `${CLAUDE_SKILL_DIR}` means the directory that contains this SKILL.md. If your environment does not substitute it, use that directory's real path.

## Settings

The settings are stored in `~/.config/english-together/config` (or `$ENGLISH_TOGETHER_CONFIG`). Always read and change them through the helper script. Never edit the file directly.

| Key | Values | Default | Meaning |
|---|---|---|---|
| `enabled` | `true` / `false` | `false` | Whether the mode stays on for every conversation |
| `ratio` | 0–100, in steps of 10 | `20` | Share of English in your prose |
| `correction` | `on` / `off` | `on` | Whether to add gentle tips about the user's English |

```sh
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh show
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set ratio 30        # rounded to the nearest 10
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set enabled on|off
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set correction on|off
```

## Handling the request

Arguments: `$ARGUMENTS`

If the arguments above are empty or were not substituted, work out the intent from the user's message instead. For example, 「英語30%で話して」 means `30`, 「英語多めで」 means the current ratio plus 10, 「英語少なめで」 means the current ratio minus 10 (clamped to 0–100), and 「添削はいらない」 means `correct off`.

| Input | Action |
|---|---|
| (empty) | `set enabled on`, then keep the current ratio |
| a number such as `30` or `30%` | `set ratio <n>`, then `set enabled on` |
| `on` / `off` | `set enabled on` / `set enabled off` |
| `correct on` / `correct off` | `set correction on` / `set correction off` |
| `status` | `show` only |

Steps:

1. Run the matching `config.sh` command(s). If the script exits with an error, show the error and the valid inputs from the table above, then stop.
2. Confirm the result in one short line in the new style. For example: `english-together: ON — English 30%, correction on`. When the user turns the mode off, confirm in plain Japanese.
3. If the mode is on, read `${CLAUDE_SKILL_DIR}/references/rules.md` unless its rules are already in your context. From this reply on, follow those rules with the new settings.
4. If the mode is off, reply normally from now on, and ignore any earlier english-together instructions in this conversation.

## When the mode is already on

In Claude Code, a hook re-injects the rules and the current settings each session and adds a one-line reminder to every message. Follow the latest reminder.

In agents without hooks, run `config.sh show` once at the start of the conversation to load the settings, then follow `references/rules.md` until the user changes or turns off the mode.
