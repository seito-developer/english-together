---
name: english-together
description: Mixed-language conversation mode for language learners. The assistant mixes the language you are learning into its replies at a set ratio (0–100%), understands mixed-language instructions, and can gently correct you. Supports Japanese speakers learning English (ja2en) and English speakers learning Japanese (en2ja). Use when the user asks to talk in mixed Japanese and English, to change the ratio (e.g. "英語30%で話して", "英語多めにして", "more Japanese please", "/english-together 50"), to switch direction, to turn the mode or the automatic adjustment on or off, to toggle corrections, or to check the current settings.
argument-hint: "[0-100 | on | off | correct on|off | direction ja2en|en2ja | adaptive on|off | status]"
allowed-tools: Bash(sh ${CLAUDE_SKILL_DIR}/scripts/config.sh *) Read(${CLAUDE_SKILL_DIR}/references/*)
---

# english-together

english-together helps a language learner practise through everyday conversation with you. You mix the language they are learning into your replies at a configured ratio.

In this file, `${CLAUDE_SKILL_DIR}` means the directory that contains this SKILL.md. If your environment does not substitute it, use that directory's real path.

## Settings

The settings are stored in `~/.config/english-together/config` (or `$ENGLISH_TOGETHER_CONFIG`). Always read and change them through the helper script. Never edit the file directly.

| Key | Values | Default | Meaning |
|---|---|---|---|
| `enabled` | `true` / `false` | `false` | Whether the mode stays on for every conversation |
| `ratio` | 0–100, in steps of 10 | `20` | Share of the learning language in your prose |
| `correction` | `on` / `off` | `on` | Whether to add gentle tips about the user's writing |
| `direction` | `ja2en` / `en2ja` | `ja2en` | `ja2en`: Japanese speaker learning English. `en2ja`: English speaker learning Japanese |
| `adaptive` | `on` / `off` | `on` | Whether the ratio follows the user automatically |
| `smooth_sessions` | 0–2 | `0` | Internal counter for the adaptive ratio. Never set it by hand |

```sh
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh show
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set ratio 30            # rounded to the nearest 10
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set enabled on|off
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set correction on|off
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set direction ja2en|en2ja
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh set adaptive on|off
sh ${CLAUDE_SKILL_DIR}/scripts/config.sh adapt down              # only when the user says it was too hard
```

## Handling the request

Arguments: `$ARGUMENTS`

If the arguments above are empty or were not substituted, work out the intent from the user's message instead. For example, 「英語30%で話して」 means `30`, 「英語多めで」 and "more English" mean the current ratio plus 10, 「英語少なめで」 and "less English" mean the current ratio minus 10 (clamped to 0–100), 「添削はいらない」 means `correct off`, and "I'm an English speaker learning Japanese" means `direction en2ja`.

| Input | Action |
|---|---|
| (empty) | `set enabled on`, then keep the current ratio |
| a number such as `30` or `30%` | `set ratio <n>`, then `set enabled on` |
| `on` / `off` | `set enabled on` / `set enabled off` |
| `correct on` / `correct off` | `set correction on` / `set correction off` |
| `direction ja2en` / `direction en2ja` | `set direction <value>` |
| `adaptive on` / `adaptive off` | `set adaptive on` / `set adaptive off` |
| `status` | `show` only |

Steps:

1. Run the matching `config.sh` command(s). If the script exits with an error, show the error and the valid inputs from the table above, then stop.
2. Confirm the result in one short line in the new style. For example: `english-together: ON — ja2en, 30%, correction on, adaptive on`. When the user turns the mode off, confirm in their base language.
3. If the mode is on, read `${CLAUDE_SKILL_DIR}/references/rules-core.md` and the level table for the current direction (`references/levels-ja2en.md` or `references/levels-en2ja.md`), unless they are already in your context. From this reply on, follow them with the new settings.
4. If the mode is off, reply normally from now on, and ignore any earlier english-together instructions in this conversation.

## When the mode is already on

In Claude Code, a hook re-injects the rules and the current settings each session and adds a one-line reminder to every message. Follow the latest reminder.

In agents without hooks, run `config.sh show` once at the start of the conversation to load the settings, then follow the rules until the user changes or turns off the mode. There is no session hook to raise the ratio in those agents, so the adaptive ratio only lowers it; the user can raise it whenever they like.
