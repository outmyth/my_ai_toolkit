# My AI Toolkit

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls. Pre-wired for Claude Code, Cursor, VS Code, GitHub Copilot, and Codex.

## The Problems

From Andrej's post:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

## The Solution

Four principles in one file that directly address these issues:

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Leverage through tests-first, verifiable success criteria |

See [`EXAMPLES.md`](EXAMPLES.md) for concrete code samples of each principle.

## Install

Pick the file that matches your tool. Each one is the same content in the location that tool reads.

### Claude Code

**Option A: Plugin marketplace (recommended)**

```
/plugin marketplace add outmyth/my_ai_toolkit
/plugin install karpathy-guidelines@my-ai-toolkit
```

**Option B: Per-project `CLAUDE.md`**

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/outmyth/my_ai_toolkit/main/CLAUDE.md
```

To append to an existing `CLAUDE.md`:

```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/outmyth/my_ai_toolkit/main/CLAUDE.md >> CLAUDE.md
```

### Cursor

Copy the rule into your project:

```bash
mkdir -p .cursor/rules
curl -o .cursor/rules/karpathy-guidelines.mdc \
  https://raw.githubusercontent.com/outmyth/my_ai_toolkit/main/.cursor/rules/karpathy-guidelines.mdc
```

It is committed with `alwaysApply: true`. See [`CURSOR.md`](CURSOR.md) for details.

### VS Code / GitHub Copilot

Copilot Chat (in VS Code or on github.com) reads `.github/copilot-instructions.md`:

```bash
mkdir -p .github
curl -o .github/copilot-instructions.md \
  https://raw.githubusercontent.com/outmyth/my_ai_toolkit/main/.github/copilot-instructions.md
```

### Codex

OpenAI Codex CLI reads `AGENTS.md` from the project root (and `~/.codex/AGENTS.md` globally):

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/outmyth/my_ai_toolkit/main/AGENTS.md
```

## Workflow Commands

Reusable slash commands adapted from [Zevi's AI Development Workflow](https://shorthaired-billboard-f9a.notion.site/Zevi-s-AI-Development-Workflow-2c86baffbc90810fa63bd0ee8ecffce9). Each command is a markdown file with a YAML `description` header and a prompt body.

| Command | Purpose |
|---------|---------|
| `/create-issue` | Capture a bug or feature idea quickly while mid-development |
| `/explore` | Understand the problem and current code before writing any code |
| `/create-plan` | Generate a markdown execution plan with status tracking |
| `/execute` | Implement the approved plan step by step, updating status as you go |
| `/code-review` | Comprehensive code review (logging, errors, types, perf, security) |
| `/peer-review` | Critically evaluate review findings from another model before acting |
| `/document` | Update documentation (incl. CHANGELOG) after code changes |
| `/learning-opportunity` | Pause and explain a concept at three increasing depths |

**Claude Code & Cursor** read these files natively from `.claude/commands/` and `.cursor/commands/`. Type `/` in chat to see the list.

**VS Code / Copilot / Codex** don't have project-scoped slash commands — open the file in `.claude/commands/<name>.md` and copy the prompt body into chat.

> `/code-review` is renamed from Zevi's `/review` to avoid shadowing the Claude Code built-in `/review`.

## Project Templates

System prompts for separate ChatGPT or Claude **Projects** (not auto-loaded by an IDE — paste them into a Project's custom instructions):

- [`projects/cto.md`](projects/cto.md) — A "CTO" persona that pushes back, asks clarifying questions, and breaks work into phases before you build.
- [`projects/interview-coach.md`](projects/interview-coach.md) — Brutally honest PM interview prep coach with a mock-interview mode.

## Repo Layout

```
.claude-plugin/                  Claude Code plugin manifest
.claude/commands/                Claude Code slash commands
.cursor/commands/                Cursor slash commands
.cursor/rules/                   Cursor project rule (alwaysApply)
.github/copilot-instructions.md  VS Code + GitHub Copilot
.github/workflows/               CI (upstream sync check)
AGENTS.md                        Codex
CLAUDE.md                        Claude Code per-project
CURSOR.md                        Cursor setup notes
EXAMPLES.md                      Worked examples of each principle
projects/                        System prompts for ChatGPT/Claude Projects
skills/karpathy-guidelines/      Portable skill (SKILL.md)
```

## How to Know It's Working

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"

## Tradeoff

These guidelines bias toward **caution over speed**. For trivial tasks (typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

## Quick Tips

- **When context gets too long:** Start a fresh session with just the plan file.
- **When AI keeps failing at something:** Ask "What in your system prompt or tooling made you make this mistake?" Then update your docs so it doesn't happen again.
- **Model picks (Zevi's defaults):** Claude for planning and complex logic. Codex for gnarly bugs. Gemini for UI. Cursor's Composer when speed matters.

## Credits

Principles derived from [Andrej Karpathy](https://x.com/karpathy/status/2015883857489522876). Distribution structure adapted from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills). Slash commands and project templates from [Zevi's AI Development Workflow](https://shorthaired-billboard-f9a.notion.site/Zevi-s-AI-Development-Workflow-2c86baffbc90810fa63bd0ee8ecffce9).

## License

MIT
