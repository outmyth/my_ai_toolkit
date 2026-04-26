# Using this repo with Cursor

This project includes a **Cursor project rule** so the Karpathy-inspired behavioral guidelines apply automatically when you work here.

## In this repository

1. Open the folder in Cursor.
2. The rule [`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc) is committed with `alwaysApply: true`, so you do not need extra installation steps.
3. In Cursor, you can confirm it under **Settings → Rules** (or the project rules UI), where `karpathy-guidelines` should appear.

## Use the same guidelines in another project

**Cursor (recommended):** Copy `.cursor/rules/karpathy-guidelines.mdc` into that project's `.cursor/rules/` directory (create the folders if needed). Adjust or merge with existing rules as you like.

**Other tools:** If a stack only supports a root instruction file, copy [`CLAUDE.md`](CLAUDE.md) (or [`AGENTS.md`](AGENTS.md)) into that project instead, or merge its contents into your existing instructions.

## Optional: personal Agent Skills

If you want the same content as a reusable skill under `~/.cursor/skills`, use [`skills/karpathy-guidelines/SKILL.md`](skills/karpathy-guidelines/SKILL.md). You can copy or symlink it into your personal skills directory; use whatever layout you use for other skills.

## Tool-by-tool

- **Claude Code:** Install via the plugin marketplace or copy [`CLAUDE.md`](CLAUDE.md) per-project.
- **Cursor:** Use the committed `.cursor/rules/` file. Cursor does not read `.claude-plugin/` or `CLAUDE.md` by default.
- **VS Code / GitHub Copilot:** Copy [`.github/copilot-instructions.md`](.github/copilot-instructions.md) into the target repo.
- **Codex:** Copy [`AGENTS.md`](AGENTS.md) into the target repo (or `~/.codex/AGENTS.md` for a global rule).

## For contributors

When you change the four principles, keep these in sync:

- [`CLAUDE.md`](CLAUDE.md)
- [`AGENTS.md`](AGENTS.md)
- [`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc)
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md)
- [`skills/karpathy-guidelines/SKILL.md`](skills/karpathy-guidelines/SKILL.md)
