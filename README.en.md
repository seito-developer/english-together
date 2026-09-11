# english-together

> "Let's together!"

A **Claude Code plugin / Agent Skill** that mixes English into your Japanese conversations with AI, so Japanese learners of English can practice without burning out.

[日本語の README](README.md)

Talking to an AI in 100% English is tiring, and most learners give up. With english-together, the AI's replies contain **English at the ratio you choose (0–100%)**. You pick up English steadily while you code, debug and research as usual.

- **Mixed replies**: set the English ratio in steps of 10%. Low ratios swap in English words; higher ratios move to phrases and then whole sentences.
- **Mixed input**: instructions such as 「この function の bug を fix して」 are understood as-is.
- **Gentle corrections**: if your English is clearly unnatural, the reply ends with a one- or two-line 💡 English tip. You can turn this off.
- **Safe where it matters**: code, commands, commit messages, generated documents and critical warnings are never mixed.

Inspired by the Chrome extension [Mazelingo](https://chromewebstore.google.com/detail/mazelingo/bhdngeocokoeblnnlhjibojcadefimpi), which mixes Japanese and English on web pages. english-together brings the same idea to **conversations with AI in the CLI or IDE**.

## Examples

Question: 「HTTP の GET と POST の違いを教えて」 ("What's the difference between GET and POST?")

| English ratio | Sample reply |
|---|---|
| 20% | GET は data を取得するための method で、parameter は URL に付きます。 |
| 50% | GET は data を取得するための method で、parameters go in the URL, so URL に丸見えになります。 |
| 80% | GET retrieves（取得する）data from the server. Parameters go in the URL, so they show up in the browser history. |
| 100% | GET retrieves data from the server. Parameters go in the URL, so they show up in the browser history. |

A correction:

```
💡 English tip: "Please explain me about what is the docker compose" → "Please explain to me what Docker Compose is."（explain は「explain to 人」の形になります）
```

## Installation

### Claude Code (recommended)

Run these commands inside Claude Code:

```
/plugin marketplace add seito-developer/english-together
/plugin install english-together@english-together
```

The mode is OFF after installation. Turn it on with `/english-together`.

### Other agents (Codex CLI, Cursor, GitHub Copilot, and more)

Use the [skills CLI](https://github.com/vercel-labs/skills) to install into any agent that supports Agent Skills:

```sh
npx skills add seito-developer/english-together
```

To install by hand, copy `skills/english-together/` into your agent's skills directory (for example `~/.agents/skills/`).

Hooks are specific to Claude Code, so in other agents you invoke the skill in each conversation (for example 「english-together で英語30%で話して」). To keep the mode on without invoking it every time, add the [AGENTS.md snippet](docs/agents-md-snippet.md) to your project or user AGENTS.md.

## Usage

| Command | Action |
|---|---|
| `/english-together` | Turn the mode on with the current settings |
| `/english-together 30` | Set the English ratio to 30% and turn the mode on (steps of 10; 35 rounds to 40) |
| `/english-together off` | Turn the mode off |
| `/english-together on` | Turn the mode on |
| `/english-together correct off` | Stop corrections (`correct on` resumes them) |
| `/english-together status` | Show the current settings |

You can also just ask in plain language: 「英語30%で話して」 (30% English), 「英語多めにして」 (more English), 「添削はいらない」 (no corrections).

> If another plugin uses the same command name, use the full name `/english-together:english-together`.

## Settings

Settings are saved to `~/.config/english-together/config` and persist across sessions. All agents share this file.

```
enabled=false     # true keeps the mode on in every conversation
ratio=20          # English ratio (0-100, steps of 10)
correction=on     # corrections (on / off)
```

Set the `ENGLISH_TOGETHER_CONFIG` environment variable to use a different path.

## What is never mixed

- Code blocks, inline code, commands, file paths, URLs and error messages
- Anything saved to a file or sent elsewhere: commit messages, code comments, generated documents, PR and issue text
- Critical warnings and confirmations (destructive operations, security, data loss): written in Japanese to prevent misunderstandings

## How it works

```
skills/english-together/
├── SKILL.md              # commands and how to change settings
├── references/rules.md   # mixing rules (definition and examples per ratio)
└── scripts/config.sh     # reads and writes the settings file (POSIX sh)
hooks/
├── hooks.json            # SessionStart / UserPromptSubmit hooks
└── inject.sh             # injects rules and settings only when ON
```

In Claude Code, the rules are injected at session start and again after compaction, and every message gets a one-line reminder. This keeps the ratio stable in long conversations. When the mode is off, nothing is injected and no tokens are spent.

## Uninstall

```
/plugin uninstall english-together@english-together
```

To remove your settings as well, delete `~/.config/english-together/`.

## Development

```sh
sh tests/test_config.sh && sh tests/test_inject.sh   # unit tests
claude plugin validate . --strict                    # validate manifests
claude --plugin-dir .                                # try it locally
```

See the [design spec (Japanese)](docs/superpowers/specs/2026-09-11-english-together-design.md) for details.

## About the name

The name comes from 「トゥギャザーしようぜ！」 ("Let's together!"), a catchphrase of the Japanese comedian Lou Oshiba, famous for mixing English into Japanese. This project turns that style into a learning tool.

## License

[MIT](LICENSE)
