# Mythium Context

A multi-tool bundle of best practices for working with AI coding agents — prompts, behavioral rules, slash commands, project templates, and the harness around them. Pre-wired for Claude Code, Cursor, VS Code, GitHub Copilot, and Codex.

## Overview

One canonical answer to *"how should an AI coding agent act in this repo?"*, expressed in every format the major tools actually read.

Each piece of content is curated from a trusted community source — Karpathy is one of them, not the only one — committed once into this repo, and mirrored into the per-tool location that editor expects (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.claude/commands/`, …). Two notify-only GitHub Actions watch the upstreams and open a PR when a source changes; see [`.github/SYNC.md`](.github/SYNC.md).

The scope spans the core areas of working with AI tools:

| Area | What's here today |
|------|-------------------|
| **Prompt engineering** | Per-tool system prompts, 8 reusable slash commands, 2 ChatGPT/Claude Project templates |
| **Behavioral rules** | A four-principle behavioral ruleset for LLM coding pitfalls — see [Sources](#sources) for the full table and [`EXAMPLES.md`](EXAMPLES.md) for worked examples |
| **Harness engineering** | Claude Code plugin manifest, daily sync workflows that watch each external source and open notify-only PRs |
| **Context management** | One source of truth per topic, mirrored into the location each editor reads natively — no per-tool drift |
| **Memory** | *Planned — recommendations welcome.* |
| **RAG knowledge base** | *Planned — recommendations welcome.* |

See [Sources](#sources) below for which external author each piece comes from.

## Install

Each source has its own install instructions in its [Sources](#sources) subsection — install only what you want.

If you're working *in this repo*, everything is already wired up; no install needed.

## Sources

Everything in this repo is derived from one of the external sources below. Each has its own license — treat the originals as authoritative. To add a new source, follow [`.github/SYNC.md`](.github/SYNC.md).

### Andrej Karpathy — LLM coding observations

[Original X post](https://x.com/karpathy/status/2015883857489522876) · distributed via [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) · auto-synced by [`upstream-sync-check.yml`](.github/workflows/upstream-sync-check.yml) (watches HEAD SHA).

**Contributes — four behavioral principles**

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Vague goals — replace with verifiable success criteria |

The same ruleset is installed at `CLAUDE.md`, `AGENTS.md`, `.cursor/rules/karpathy-guidelines.mdc`, `.github/copilot-instructions.md`, and `skills/karpathy-guidelines/SKILL.md` so each tool reads it natively. Worked examples in [`EXAMPLES.md`](EXAMPLES.md).

**Tradeoff** — these guidelines bias toward caution over speed. For trivial tasks (typo fixes, obvious one-liners), use judgment.

**Signals it's working** — fewer unnecessary changes in diffs, fewer rewrites from overcomplication, clarifying questions arrive before implementation, clean minimal PRs.

**Install in another project**

Claude Code (plugin):

```
/plugin marketplace add outmyth/mythium-context
/plugin install karpathy-guidelines@mythium-context
```

Or copy individual files:

```bash
RAW=https://raw.githubusercontent.com/outmyth/mythium-context/main

# Claude Code
curl -o CLAUDE.md $RAW/CLAUDE.md

# Cursor
mkdir -p .cursor/rules
curl -o .cursor/rules/karpathy-guidelines.mdc $RAW/.cursor/rules/karpathy-guidelines.mdc

# VS Code / GitHub Copilot
mkdir -p .github
curl -o .github/copilot-instructions.md $RAW/.github/copilot-instructions.md

# Codex
curl -o AGENTS.md $RAW/AGENTS.md
```

### Zevi — AI Development Workflow

[Notion page](https://shorthaired-billboard-f9a.notion.site/Zevi-s-AI-Development-Workflow-2c86baffbc90810fa63bd0ee8ecffce9) · auto-synced by [`notion-sync-check.yml`](.github/workflows/notion-sync-check.yml) (watches `last_edited_time`).

All Zevi-derived files use a `zevi-` prefix so they group together and don't collide with built-ins or other sources.

**Contributes — 8 slash commands** (in `.claude/commands/zevi-*.md`, mirrored in `.cursor/commands/zevi-*.md`). Type `/zevi` in Claude Code or Cursor to tab-complete the set.

| Command | Purpose |
|---------|---------|
| `/zevi-create-issue` | Capture a bug or feature idea quickly while mid-development |
| `/zevi-explore` | Understand the problem and current code before writing any code |
| `/zevi-create-plan` | Generate a markdown execution plan with status tracking |
| `/zevi-execute` | Implement the approved plan step by step, updating status as you go |
| `/zevi-review` | Comprehensive code review (logging, errors, types, perf, security) |
| `/zevi-peer-review` | Critically evaluate review findings from another model before acting |
| `/zevi-document` | Update documentation (incl. CHANGELOG) after code changes |
| `/zevi-learning-opportunity` | Pause and explain a concept at three increasing depths |

VS Code / Copilot / Codex don't have project-scoped slash commands — open the file and copy the prompt body into chat.

**Contributes — 2 Project system prompts** (paste into a ChatGPT or Claude *Project*'s custom instructions, not auto-loaded by an IDE):

- [`projects/zevi-cto.md`](projects/zevi-cto.md) — A "CTO" persona that pushes back, asks clarifying questions, and breaks work into phases before you build.
- [`projects/zevi-interview-coach.md`](projects/zevi-interview-coach.md) — Brutally honest PM interview prep coach with a mock-interview mode.

**Quick tips**

- When context gets too long, start a fresh session with just the plan file.
- When AI keeps failing at something, ask *"What in your system prompt or tooling made you make this mistake?"* — then update your docs so it doesn't happen again.
- Model picks (Zevi's defaults): Claude for planning and complex logic, Codex for gnarly bugs, Gemini for UI, Cursor's Composer when speed matters.

**Install in another project**

```bash
RAW=https://raw.githubusercontent.com/outmyth/mythium-context/main
COMMANDS="create-issue explore create-plan execute review peer-review document learning-opportunity"

# Slash commands — Claude Code
mkdir -p .claude/commands
for c in $COMMANDS; do curl -o ".claude/commands/zevi-$c.md" "$RAW/.claude/commands/zevi-$c.md"; done

# Slash commands — Cursor (mirror)
mkdir -p .cursor/commands
for c in $COMMANDS; do curl -o ".cursor/commands/zevi-$c.md" "$RAW/.cursor/commands/zevi-$c.md"; done
```

Project templates aren't auto-loaded by an IDE — open the file on GitHub and paste the body into a ChatGPT or Claude *Project*'s custom instructions:

- [`projects/zevi-cto.md`](projects/zevi-cto.md)
- [`projects/zevi-interview-coach.md`](projects/zevi-interview-coach.md)

## Repo Layout

```
.claude-plugin/                  Claude Code plugin manifest
.claude/commands/                Claude Code slash commands
.cursor/commands/                Cursor slash commands
.cursor/rules/                   Cursor project rule (alwaysApply)
.github/SYNC.md                  Sync workflow reference (how to add new sources)
.github/copilot-instructions.md  VS Code + GitHub Copilot
.github/workflows/               Notify-only sync workflows (see .github/SYNC.md)
AGENTS.md                        Codex
CLAUDE.md                        Claude Code per-project
CURSOR.md                        Cursor setup notes
EXAMPLES.md                      Worked examples of each principle
projects/                        System prompts for ChatGPT/Claude Projects
skills/karpathy-guidelines/      Portable skill (SKILL.md)
```

## License

MIT
