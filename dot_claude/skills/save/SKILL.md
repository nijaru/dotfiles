---
name: save
description: Use when persisting session state, updating AI context documents (ai/), and managing task progress (tk). Trigger before context compacting, session termination, or after completing a significant task.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Save (Session Persistence)

**Iron Law:** Volatile context — write findings to `ai/` or `tk` immediately. Never assume state survives compaction.

## Checklist

### 1. Tasks (`tk`)

- Close completed tasks: `tk done <id>`
- Log key findings: `tk log <id> "finding (file:line)"` — high-signal only, skip what's derivable from code
- Add remaining work: `tk add "title" -p N -d "context"`

### 2. AI Context (`ai/`)

- **STATUS.md:** Update phase, active focus, blockers.
- **README.md:** If topic files were added, changed, or deleted — update index pointers. Format: `- [Title](path) — one-line hook`. Verify all links are live; remove dead ones.
- **DESIGN.md:** Record architectural changes only.
- **DECISIONS.md:** Append to Log section: `[date] Context → Decision → Rationale`. If Log exceeds ~20 entries, run `/setup-ai` next session to compact into Principles.

### 3. Source Control

- Commit `ai/` and `.tasks/` if tracked. One logical change = one commit.
- Prefer keeping ai/ local via `.git/info/exclude`.
