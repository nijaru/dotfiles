---
name: context-save
description: >
  Update ai/ files. Triggers on: "save", "update ai/", "sync",
  task completion, session end, context switch, before /compact.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Context Save

Update ai/ files before /compact or session end.

## Triggers

- Explicit: "save", "update ai/", "save context"
- Task complete: "mark it done", "that's finished"
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
```

Read ai/STATUS.md and ai/TODO.md.

## 2. Update Task Tracking

Update ai/TODO.md:

- Remove completed tasks
- Add new tasks discovered
- Update in-progress items

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
```

## 6. Report

```
Session saved
- STATUS.md: [state summary]
- DESIGN.md: [updated/unchanged]
- TODO.md: [N pending tasks]
- Committed: [yes/no]

Next: /compact or provide follow-up prompt
```
