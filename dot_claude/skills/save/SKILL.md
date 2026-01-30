---
name: save
description: Update ai/ files and tk tasks.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save

Checkpoint session state to ai/ and tk. Goal: everything needed to resume is persisted.

**Priority:** tk and ai/ updates first (from context). Git commands last (can recover if compaction hits).

## When to Trigger

- Before `/compact`
- Session end ("done for today", "wrap up")
- Context switch ("switching to X", "different project")
- After significant work completes
- Explicit: "/save", "save context"

## When NOT to Trigger

- Mid-task (save at completion)
- Quick fixes that don't change project state
- User says "skip" or "don't save"

## 1. Update tk Tasks

You already know what was done this session—no git commands needed.

```bash
tk ls  # Check current state
```

For EACH task:

- **Completed** → `tk done <id>`
- **New work discovered** → `tk add "title" -d "context"`
- **Blocked** → Note in STATUS.md

Don't leave stale tasks. If done, mark done. If new, add it.

## 2. Update ai/ Files

**ai/STATUS.md** (always):

- Current focus, what's active
- What worked / didn't
- Blockers
- Prune old content

**ai/DESIGN.md** (if architecture changed):

- New components, patterns
- Updated interfaces

**ai/DECISIONS.md** (if decisions made):

- Context → Decision → Rationale (append)

**ai/SPRINTS.md** (if sprint progress):

- Mark completed tasks
- Update current sprint status

## 3. Health Check

| Issue              | Fix                      |
| ------------------ | ------------------------ |
| Files >500 lines   | Prune, move to subdirs   |
| Stale STATUS.md    | Remove old blockers/work |
| Outdated DESIGN.md | Update to current        |

## 4. Commit (last)

```bash
git add ai/ .tasks/
git commit -m "Update session context"
```

## 5. Report

```
## Session Saved

Tasks:
- Done: [list marked complete]
- Added: [list new]
- Pending: [N remaining]

ai/:
- STATUS.md: [summary]
- DESIGN.md: [updated/unchanged]
- SPRINTS.md: [updated/unchanged]

Committed: [yes/no]

## Next Steps

[2-4 bullet points for next session]

Ready for /compact or new session.
```
