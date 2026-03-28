---
name: codex
description: Use ONLY when explicitly asked to invoke or run the Codex CLI tool for agentic review. Do NOT trigger when "codex" appears in conversation as a model name, topic, or reference.
allowed-tools: Bash, Read, Grep, Glob
---

# Codex (Agentic Review)

Use when you want a different model to walk the repo autonomously — useful for pre-release review or validating invariants you can't easily enumerate upfront.

## When to use

- Pre-release review across a full codebase
- Bug hunt where you don't know which files are involved
- Validating a property that spans many files

## Execution

```bash
# Review against base branch
codex review --base main -o /tmp/codex-review.txt

# Freeform analysis
echo "Find all places where X invariant could be violated" | codex exec --full-auto -o /tmp/codex-reply.txt
```

**Always use `-o <file>`** — findings are lost without it.

## Cross-repo

```bash
codex --dangerously-bypass-approvals-and-sandbox -C /absolute/path/to/repo "prompt"
```
