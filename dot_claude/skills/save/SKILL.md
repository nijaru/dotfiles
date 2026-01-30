---
name: save
description: Update ai/ files and tk tasks.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save

Persist session state to ai/ and tk. Priority: tk and ai/ first (from context), git last.

**Trigger:** Before `/compact`, session end, context switch, or explicitly.

## 1. Update tk Tasks

```bash
tk ls
```

For each task:

- **Log findings first:** `tk log <id> "what was learned"` — errors, root cause, file paths
- **Mark complete:** `tk done <id>`
- **Add new:** `tk add "title" -d "context"`

Don't leave stale tasks.

## 2. Update ai/

**STATUS.md** (always): Current focus, blockers, what worked. Prune stale content.

**DESIGN.md** (if architecture changed): Components, patterns, interfaces.

**DECISIONS.md** (if decisions made): Context → Decision → Rationale.

**SPRINTS.md** (if sprint progress): Mark completed, update status.

Keep files <500 lines. Move details to subdirs if needed.

## 3. Commit

```bash
git add ai/ .tasks/
git commit -m "Update session context"
```

## 4. Report

```
## Saved

Tasks: [N done, N added, N pending]
ai/: [what changed]

## Next Session

[2-4 bullets: what to do next based on pending tasks, blockers, incomplete work]
```
