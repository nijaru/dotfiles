---
name: context-save
description: >
  Auto-triggers /save to update ai/ and beads when context suggests it's needed.
  Activates on: "update ai/", "sync", task completion, session end, context switch.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save Skill

Auto-triggers the `/save` command when context suggests state should be persisted.

## Activation Triggers

- Explicit: "update ai/", "sync beads", "save context", "save"
- Task complete: "close the bead", "mark it done", "that's finished"
- Session end: "wrap up", "done for today", "stopping here"
- Context switch: "switching to X", "moving on", "different project"
- After code-review LGTM and ready to commit

## Execution

**Prerequisite**: If code was written, run code-review first. Only save after LGTM.

Run `/save` command which handles:

1. Git status analysis
2. Bead updates (`bd close`, `bd sync`)
3. ai/ file updates (STATUS.md, DECISIONS.md, etc.)
4. Health check (prune stale content)
5. Commit & sync

## When NOT to Trigger

- Mid-task (save at completion, not during)
- Quick fixes that don't change project state
- User says "skip" or "don't save"
