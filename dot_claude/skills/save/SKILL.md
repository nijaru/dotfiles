---
name: save
description: Update ai/ files and tk tasks.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save

Checkpoint session state to ai/ and tk. Goal: everything needed to resume is persisted.

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

## 1. Review Session

What was accomplished? Run in parallel:

```bash
git diff --stat
git log --oneline -5
tk ls
```

Read ai/STATUS.md to compare against current state.

## 2. Update tk Tasks (be thorough)

Review ALL tasks against what was done:

```bash
tk ls  # Current state
```

For EACH task:

- **Completed** → `tk done <id>`
- **New work discovered** → `tk add "title"`
- **Blocked** → Note in STATUS.md

Don't leave stale tasks. If done, mark done. If new, add it.

## 3. Update ai/ Files

**ai/STATUS.md** (always):

- Current state, metrics
- What worked / didn't
- Active work
- Blockers
- Prune old content

**ai/DESIGN.md** (if architecture changed):

- New components, patterns
- Updated interfaces

**ai/DECISIONS.md** (if decisions made):

- Context → Decision → Rationale (append)

**ai/ROADMAP.md** (if phases changed):

- Phase updates, scope changes

**ai/SPRINTS.md** (if sprint progress):

- Mark completed tasks
- Update current sprint status

## 4. Health Check

| Issue              | Fix                      |
| ------------------ | ------------------------ |
| Files >500 lines   | Prune, move to subdirs   |
| Stale STATUS.md    | Remove old blockers/work |
| Outdated DESIGN.md | Update to current        |

## 5. Commit

```bash
git add ai/ .tasks/
git commit -m "Update session context"
```

## 6. Report

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

Ready for /compact or new session.
```
