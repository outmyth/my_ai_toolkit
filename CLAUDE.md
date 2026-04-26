# CLAUDE.md — My AI Toolkit

This is your unified AI coding assistant configuration. It loads all skills, rules, prompts, memory, and context from this toolkit.

---

## Active Skills

### Karpathy Guidelines (karpathy-guidelines)

@see skills/karpathy-guidelines/CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes derived from Andrej Karpathy's observations. Four principles:

1. **Think Before Coding** — State assumptions, surface tradeoffs, ask when confused.
2. **Simplicity First** — Minimum code. No speculative features or abstractions.
3. **Surgical Changes** — Touch only what the request requires. Match existing style.
4. **Goal-Driven Execution** — Define success criteria with verification loops.

---

## Rules

@see rules/

Project-wide rules that apply to all tasks. Add `.md` files here for coding standards, commit conventions, review checklists, etc.

## Prompts

@see prompts/

Reusable prompt templates for common workflows (code review, bug triage, architecture decisions, etc.)

## Memory

@see memory/

Persistent context that should carry across sessions — project decisions, tech stack choices, naming conventions, known quirks.

## Context

@see context/

Project-specific context files — architecture diagrams, dependency maps, API schemas, domain glossaries.

## Harness

@see harness/

Harness engineering configs — test scaffolds, CI/CD prompt chains, evaluation frameworks, agent orchestration patterns.
