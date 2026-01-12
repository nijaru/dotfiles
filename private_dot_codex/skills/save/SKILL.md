---
name: save
description: >
  Checkpoint session state to ai/ and tk tasks.
  Triggers on: "save context", "save session", "wrap up", "done for today".
metadata:
  short-description: Checkpoint session state
---

# Context Save

Checkpoint session state to ai/ and tk. Goal: everything needed to resume is persisted.

## Triggers

- "save context", "save session", "save"
- "wrap up", "done for today", "switching projects"
- Before compaction

## Workflow

### 1. Review Session

What was accomplished? Run in parallel:

```bash
git diff --stat
git log --oneline -5
tk ls
```

Read ai/STATUS.md to compare against current state.

### 2. Update tk Tasks

Review ALL tasks against what was done:

- **Completed** -> `tk done <id>`
- **New work discovered** -> `tk add "title"`
- **Blocked** -> Note in STATUS.md

### 3. Update ai/ Files

**ai/STATUS.md** (always):

- Current state, metrics
- What worked / didn't
- Active work
- Blockers
- Prune old content

**ai/DESIGN.md** (if architecture changed)
**ai/DECISIONS.md** (if decisions made)
**ai/ROADMAP.md** (if phases changed)

### 4. Commit

```bash
git add ai/ .tasks/
git commit -m "Update session context"
```

### 5. Report

```
## Session Saved

Tasks:
- Done: [list marked complete]
- Added: [list new]
- Pending: [N remaining]

ai/:
- STATUS.md: [summary]
- DESIGN.md: [updated/unchanged]

Committed: [yes/no]

Ready for compaction or new session.
```
