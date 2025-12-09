---
name: review
description: >
  Auto-triggers code review when quality check needed.
  Activates on: "review this", "is this ready", "check the code", "LGTM?",
  before PR/release, or when uncertain about code quality.
allowed-tools: Read, Grep, Glob, Bash
---

# Review Skill

When activated, run `/review` command.

## Triggers

- "is this ready?", "review this", "check the code"
- "ready to push", "before I push", "LGTM?"
- Before creating PR or release
- "done with this", "finished the feature"
- User uncertain about code quality

## Execution

Run `/review` with detected scope (feature branch diff, staged changes, etc.)

See `/review` for full checklist: design, naming, comments, debug cleanup,
code smells, correctness, performance, idioms, security, tests.
