# english-together

You can see the README in Japanese here.  
[日本語の README](README.md)

"If I did all my AI conversations in English, that would be English practice, wouldn't it?"

Have you ever decided to switch your conversations with AI over to English?

But once you actually try it:
"Reading 100% English is hard work."
"Putting everything I want to say into English takes time, and it wears me out."
Two or three days later, you are back where you started.

So what about half and half?
Or 30:70 between your own language and the one you are learning?

That you could keep up — and that idea is where this skill came from.

This is a **plugin / Agent Skill for AI agents** that lowers the cognitive load of language learning by **mixing the two languages together** in your conversations with AI. (It works with Claude Code and Codex.)
The name "English Together" is inspired by 「トゥギャザーしようぜ！」 ("Let's together!"), the catchphrase of Lou Oshiba, a Japanese TV personality known for mixing English into Japanese.

https://github.com/user-attachments/assets/bdc3ffd4-977a-46ce-a4cc-a149e864c392

Talking to an AI in 100% English is tiring, and most learners give up. With english-together, the AI's replies contain **English at the ratio you choose (0–100%)**. You pick up English steadily while you code, debug and research as usual.

- **Mixed replies**: set the English ratio in steps of 10%. Low ratios swap in English words; higher ratios move to phrases and then whole sentences.
- **Mixed input**: instructions such as 「この function の bug を fix して」 are understood as-is.
- **Gentle corrections**: if your English is clearly unnatural, the reply ends with a one- or two-line 💡 English tip. You can turn this off.
- **Adaptive ratio**: say "in English please" and it goes down; keep going smoothly and it creeps up. You can turn this off.
- **Both directions**: English speakers learning Japanese can flip it around with `direction en2ja` and get Japanese mixed into English replies.
- **Safe where it matters**: code, commands, commit messages, generated documents and critical warnings are never mixed.

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

Open Claude Code, then type each command below into the input box and press Enter.

**Step 1: Add the source**

```
/plugin marketplace add seito-developer/english-together
```

This registers the source of english-together (this GitHub repository) with Claude Code. Think of it as adding an app store.

**Step 2: Install the plugin**

```
/plugin install english-together@english-together
```

This installs english-together from the source you just added. The part before `@` is the plugin name, and the part after it is the source name. Both are english-together.

**Step 3: Turn it on**

```
/english-together
```

The mode is OFF after installation, so this command turns it on.

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
| `/english-together adaptive off` | Stop adjusting the ratio automatically (`adaptive on` resumes it) |
| `/english-together direction en2ja` | Switch direction (`ja2en` switches back; see "Two directions" below) |
| `/english-together status` | Show the current settings |

You can also just ask in plain language: "more Japanese please", "say that in English", 「英語30%で話して」, 「添削はいらない」.

> If another plugin uses the same command name, use the full name `/english-together:english-together`.

## Adaptive ratio

It is hard to judge your own level, so english-together moves the ratio for you (on by default).

- **It goes down** by 10% only when you say so — "say that in English", "I don't understand", 「日本語で言って」. The reply is redone at the lower ratio, and one short line tells you where it is now.
- **It goes up** by 10% when three sessions in a row pass without a single request to lower it. The change happens when you next start Claude Code, never in the middle of a conversation.
- Asking "what does X mean?" is a learning question, so it does not lower the ratio. Say it plainly when you want it lowered.
- To take full control, run `/english-together adaptive off`.

Hooks are specific to Claude Code, so **the automatic increase does not happen in other agents**. Lowering and manual changes work everywhere.

## Two directions

`direction` decides which language you are learning. `ratio` always means the share of **the language you are learning**.

| Setting | Who it is for | Base of the reply | Language mixed in |
|---|---|---|---|
| `ja2en` (default) | Japanese speakers learning English | Japanese | English |
| `en2ja` | English speakers learning Japanese | English | Japanese |

```
/english-together direction en2ja
/english-together 30
```

A reply at 30% Japanese:

> A **reverse proxy** is a サーバー (sābā — server) that sits **in front of** your real servers.

The Japanese script is the hardest part at the start, so up to 30% every Japanese word gets romaji and its English meaning the first time it appears in a reply. Above 40%, only the less common words are glossed. Corrections follow the direction too: in `en2ja` your Japanese gets a 💡 日本語 tip.

## Settings

Settings are saved to `~/.config/english-together/config` and persist across sessions. All agents share this file.

```
enabled=false       # true keeps the mode on in every conversation
ratio=20            # share of the language you are learning (0-100, steps of 10)
correction=on       # corrections (on / off)
direction=ja2en     # ja2en: learning English / en2ja: learning Japanese
adaptive=on         # automatic ratio adjustment (on / off)
smooth_sessions=0   # internal counter for the adaptive ratio (do not edit)
```

Set the `ENGLISH_TOGETHER_CONFIG` environment variable to use a different path.

## What is never mixed

- Code blocks, inline code, commands, file paths, URLs and error messages
- Anything saved to a file or sent elsewhere: commit messages, code comments, generated documents, PR and issue text
- Critical warnings and confirmations (destructive operations, security, data loss): written in Japanese to prevent misunderstandings

## How it works

```
skills/english-together/
├── SKILL.md                        # commands and how to change settings
├── references/rules-core.md        # rules shared by both directions
├── references/levels-ja2en.md      # level table for learning English
├── references/levels-en2ja.md      # level table for learning Japanese
└── scripts/config.sh               # reads and writes the settings file (POSIX sh)
hooks/
├── hooks.json                      # SessionStart / UserPromptSubmit hooks
└── inject.sh                       # injects rules and settings only when ON
```

In Claude Code, the rules are injected at session start and again after compaction, and every message gets a one-line reminder. This keeps the ratio stable in long conversations. Only the core rules and the level table for the direction in use are injected. When the mode is off, nothing is injected and no tokens are spent.

Raising the ratio is decided by the hook, which only counts sessions at startup. Lowering is decided by the model, but every write goes through `config.sh`, so the settings file cannot be damaged.

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

## License

[MIT](LICENSE)
