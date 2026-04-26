# Mythium Context

A multi-tool bundle of best practices for working with AI coding agents — prompts, behavioral rules, slash commands, project templates, and the harness around them. Pre-wired for Claude Code, Cursor, VS Code, GitHub Copilot, and Codex.

## Overview

One canonical answer to *"how should an AI coding agent act in this repo?"*, expressed in every format the major tools actually read.

Each piece of content is curated from a trusted community source — Karpathy is one of them, not the only one — committed once into this repo, and mirrored into the per-tool location that editor expects (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.claude/commands/`, …). Two notify-only GitHub Actions watch the upstreams and open a PR when a source changes; see [`.github/SYNC.md`](.github/SYNC.md).

The scope spans the core areas of working with AI tools:

| Area | What's here today |
|------|-------------------|
| **Prompt engineering** | Per-tool system prompts, 8 reusable slash commands, 2 ChatGPT/Claude Project templates |
| **Behavioral rules** | A four-principle behavioral ruleset for LLM coding pitfalls — see [Best Practises](#best-practises) for the full table and [`EXAMPLES.md`](EXAMPLES.md) for worked examples |
| **Harness engineering** | Claude Code plugin manifest, daily sync workflows that watch each external source and open notify-only PRs |
| **Context management** | One source of truth per topic, mirrored into the location each editor reads natively — no per-tool drift |
| **Memory** | *Planned — recommendations welcome.* |
| **RAG knowledge base** | *Planned — recommendations welcome.* |

See [Best Practises](#best-practises) for which external author each piece comes from, then [Install](#install) for how to pull them into your project.

## Best Practises

Each best practice in this repo is curated from an external community source. Each has its own license — treat the originals as authoritative. To add a new source, follow [`.github/SYNC.md`](.github/SYNC.md).

### Andrej Karpathy — LLM coding observations

[Original X post](https://x.com/karpathy/status/2015883857489522876) · distributed via [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) · auto-synced by [`upstream-sync-check.yml`](.github/workflows/upstream-sync-check.yml) (watches HEAD SHA).

**Contributes — four behavioral principles**

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Vague goals — replace with verifiable success criteria |

The same ruleset is installed at `CLAUDE.md`, `AGENTS.md`, `.cursor/rules/karpathy-guidelines.mdc`, `.github/copilot-instructions.md`, `skills/karpathy-guidelines/SKILL.md`, and `.claude/skills/karpathy-guidelines/SKILL.md` so each tool reads it natively. Worked examples in [`EXAMPLES.md`](EXAMPLES.md).

**Tradeoff** — these guidelines bias toward caution over speed. For trivial tasks (typo fixes, obvious one-liners), use judgment.

**Signals it's working** — fewer unnecessary changes in diffs, fewer rewrites from overcomplication, clarifying questions arrive before implementation, clean minimal PRs.

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

## Install

Pick your tool. Each block pulls the relevant files from every applicable source — drop any line you don't want.

If you're working *in this repo*, everything is already wired up; no install needed.

### Claude Code

Plugin (installs the Karpathy ruleset as a skill):

```
/plugin marketplace add outmyth/mythium-context
/plugin install karpathy-guidelines@mythium-context
```

Manual files:

```bash
RAW=https://raw.githubusercontent.com/outmyth/mythium-context/main
COMMANDS="create-issue explore create-plan execute review peer-review document learning-opportunity"

# Karpathy — behavioral ruleset
curl -o CLAUDE.md $RAW/CLAUDE.md

# Zevi — 8 slash commands (/zevi-*)
mkdir -p .claude/commands
for c in $COMMANDS; do curl -o ".claude/commands/zevi-$c.md" "$RAW/.claude/commands/zevi-$c.md"; done
```

### Cursor

```bash
RAW=https://raw.githubusercontent.com/outmyth/mythium-context/main
COMMANDS="create-issue explore create-plan execute review peer-review document learning-opportunity"

# Karpathy — behavioral ruleset (alwaysApply)
mkdir -p .cursor/rules
curl -o .cursor/rules/karpathy-guidelines.mdc $RAW/.cursor/rules/karpathy-guidelines.mdc

# Zevi — 8 slash commands (/zevi-*)
mkdir -p .cursor/commands
for c in $COMMANDS; do curl -o ".cursor/commands/zevi-$c.md" "$RAW/.cursor/commands/zevi-$c.md"; done
```

### VS Code / GitHub Copilot

```bash
mkdir -p .github
curl -o .github/copilot-instructions.md \
  https://raw.githubusercontent.com/outmyth/mythium-context/main/.github/copilot-instructions.md
```

Karpathy ruleset only — Copilot has no project-scoped slash commands. To use Zevi's prompts, open a `zevi-*.md` file and copy the body into chat manually.

### Codex

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/outmyth/mythium-context/main/AGENTS.md
```

Karpathy ruleset only — Codex CLI has no project-scoped slash commands.

### Project templates (any tool)

Not auto-loaded by an IDE — paste the body into a ChatGPT or Claude *Project*'s custom instructions:

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

## Roadmap

Captured here for revisit; **nothing in this section is implemented yet.**

### MCP server — `mythium-context-mcp`

Expose this catalog over [Model Context Protocol](https://modelcontextprotocol.io) so external agents (Claude Desktop, Claude Code, Cursor, VS Code, any MCP-aware client) can discover and fetch best practices without copying files.

**Proposed surface**

| MCP primitive | What we'd expose |
|---|---|
| **Prompts** | Each `zevi-*` slash command + each project template + a `karpathy.principles` prompt — rendered with optional args |
| **Resources** | Read-only docs: `mythium://karpathy/principles`, `mythium://karpathy/examples`, `mythium://zevi/commands/<name>`, `mythium://zevi/projects/<name>` |
| **Tools** | `list_best_practices()`, `search_best_practices(query)`, `get_best_practice(id)` |

**Distribution**

- Phase 1: `npx mythium-context-mcp` via npm (stdio transport)
- Phase 2 (optional): hosted HTTP/SSE endpoint for zero-install consumption

**Tech stack:** Node/TypeScript with `@modelcontextprotocol/sdk` — the most mature MCP ecosystem and friction-free npm distribution.

**Source of truth:** fetch from `raw.githubusercontent.com/outmyth/mythium-context/main` at runtime so updates merged into `main` flow through automatically — no MCP republish needed when a sync PR lands.

**Phased plan**

| Phase | Scope |
|---|---|
| 1 — MVP | stdio server; prompts only (8 commands + 2 templates + 1 Karpathy prompt) and one `list_best_practices` tool; publish to npm |
| 2 | Add resources + `search_best_practices` + `get_best_practice`; CI auto-publish on tag |
| 3 (optional) | Hosted HTTP/SSE endpoint at a public URL |

**Open questions to resolve before implementing**

- npm name availability — `mythium-context-mcp` vs scoped `@outmyth/mythium-context-mcp`
- Bundle content at build vs runtime fetch (leaning runtime fetch for MVP)
- Day-1 scope: prompts only, or include resources + search tools as well

**What this would not change**

Existing rule files, slash commands, project templates, plugin manifest, sync workflows, and curl install paths all keep working unchanged. MCP would be an *additional* consumption channel, not a replacement.

## License

MIT
