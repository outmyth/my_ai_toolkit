# 🧰 My AI Toolkit

A unified, portable repository for managing your AI coding assistant configuration across **Claude Code**, **Cursor**, and **OpenAI Codex CLI**.

## Philosophy

Your AI toolkit is organized into six pillars:

| Pillar | Directory | Purpose |
|--------|-----------|---------|
| **Skills** | `skills/` | Behavioral guidelines and capabilities (e.g., Karpathy guidelines) |
| **Rules** | `rules/` | Project-wide coding standards, commit conventions, review checklists |
| **Prompts** | `prompts/` | Reusable prompt templates for common workflows |
| **Memory** | `memory/` | Persistent context — decisions, tech stack, naming conventions |
| **Context** | `context/` | Project-specific files — architecture, API schemas, domain glossaries |
| **Harness** | `harness/` | Harness engineering — test scaffolds, CI/CD chains, eval frameworks |

## Installed Skills

### ✅ Karpathy Guidelines

Derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls. Source: [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills).

Four principles:
1. **Think Before Coding** — Surface assumptions and tradeoffs before writing code.
2. **Simplicity First** — Minimum code. No speculative features.
3. **Surgical Changes** — Touch only what the request requires.
4. **Goal-Driven Execution** — Define verifiable success criteria.

## Multi-Tool Support

This toolkit provides config files for three major AI coding tools:

| Tool | Config File | Location |
|------|------------|----------|
| **Claude Code** | `CLAUDE.md` | Root + each skill directory |
| **Cursor** | `.cursorrules` | Root + each skill directory |
| **OpenAI Codex** | `AGENTS.md` | Root + each skill directory |

### Quick Setup

**Claude Code** — Drop this repo in your project root. Claude Code auto-reads `CLAUDE.md`.

**Cursor** — Copy `.cursorrules` to your project root, or symlink it:
```bash
ln -s path/to/my_ai_toolkit/.cursorrules .cursorrules
```

**OpenAI Codex CLI** — Copy `AGENTS.md` to your project root, or symlink it:
```bash
ln -s path/to/my_ai_toolkit/AGENTS.md AGENTS.md
```

### Install Script

Run the install script to symlink all config files into your project:

```bash
./install.sh /path/to/your/project
```

## Adding a New Skill

1. Create a directory under `skills/your-skill-name/`
2. Add three config files:
   - `CLAUDE.md` — for Claude Code
   - `.cursorrules` — for Cursor
   - `AGENTS.md` — for OpenAI Codex
3. Reference the skill in the root config files
4. Commit and push

## Repo Structure

```
my_ai_toolkit/
├── CLAUDE.md              # Root config → Claude Code
├── .cursorrules           # Root config → Cursor
├── AGENTS.md              # Root config → OpenAI Codex
├── README.md
├── install.sh             # Symlink installer
├── skills/
│   └── karpathy-guidelines/
│       ├── CLAUDE.md
│       ├── .cursorrules
│       └── AGENTS.md
├── rules/
│   └── README.md
├── prompts/
│   └── README.md
├── memory/
│   └── README.md
├── context/
│   └── README.md
└── harness/
    └── README.md
```

## License

MIT
