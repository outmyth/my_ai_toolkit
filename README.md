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

## Repo Layout

```
.claude-plugin/                  Claude Code plugin manifest
.cursor/rules/                   Cursor project rule (alwaysApply)
.github/copilot-instructions.md  VS Code + GitHub Copilot
AGENTS.md                        Codex
CLAUDE.md                        Claude Code per-project
CURSOR.md                        Cursor setup notes
EXAMPLES.md                      Worked examples of each principle
skills/karpathy-guidelines/      Portable skill (SKILL.md)
```

## How to Know It's Working

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"

## Tradeoff

These guidelines bias toward **caution over speed**. For trivial tasks (typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

## Credits

Principles derived from [Andrej Karpathy](https://x.com/karpathy/status/2015883857489522876). Distribution structure adapted from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills).

## License

MIT
