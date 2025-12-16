---
name: context-save
description: >
  Update ai/ and sync beads. Triggers on: "save", "update ai/", "sync",
  task completion, session end, context switch, before /compact.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save

Update ai/ and sync beads before /compact or session end.

## Triggers

- Explicit: "save", "update ai/", "sync beads", "save context"
- Task complete: "close the bead", "mark it done", "that's finished"
- Session end: "wrap up", "done for today", "stopping here"
- Context switch: "switching to X", "moving on", "different project"
- After code-review LGTM and ready to commit
- Before /compact

## When NOT to Trigger

- Mid-task (save at completion, not during)
- Quick fixes that don't change project state
- User says "skip" or "don't save"

## 1. Analyze Current State

Run in parallel:

```bash
git status
git diff --stat
ls -la ai/
wc -l ai/*.md 2>/dev/null
bd list --status open 2>/dev/null  # If beads available
```

Read ai/STATUS.md. Check `bd ready` or ai/TODO.md.

## 2. Update Task Tracking

**If beads available:**

```bash
bd close <completed-ids>                    # Close completed work
bd create "remaining work" -t task -p 2     # File new issues
bd sync                                     # Flush/commit/push
```

**If using TODO.md:**

- Remove completed tasks, add new, update in-progress

## 3. Update ai/ Files

**Always update:**

- **ai/STATUS.md** — Current state, what worked/didn't, active work, blockers

**If changes this session:**

- **ai/DESIGN.md** — Architecture changes, new components
- **ai/DECISIONS.md** — New architectural decisions
- **ai/ROADMAP.md** — Phase changes, major pivots

## 4. Health Check

| Issue                          | Fix                                               |
| ------------------------------ | ------------------------------------------------- |
| Session files >500 lines       | Prune historical content, move details to subdirs |
| Completed tasks in TODO.md     | Delete them (trust git)                           |
| Stale content in STATUS.md     | Remove old blockers, completed work               |
| Superseded design in DESIGN.md | Update to current architecture                    |

## 5. Commit & Sync

```bash
git add ai/
git commit -m "Update ai/ context"
bd sync 2>/dev/null  # Sync beads if available
```

## 6. Report

```
Session saved
- STATUS.md: [state summary]
- DESIGN.md: [updated/unchanged]
- Tasks: [N open in beads / N pending in TODO.md]
- Beads synced: [yes/no/n/a]
- Committed: [yes/no]

Next: /compact or provide follow-up prompt
```
