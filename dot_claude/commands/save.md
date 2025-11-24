Update ai/ files before /compact or session end.

## 1. Analyze Current State

Run in parallel:
```bash
git status
git diff --stat
ls -la ai/
wc -l ai/*.md 2>/dev/null
```

Read ai/STATUS.md and ai/TODO.md.

## 2. Update ai/ Files

**Always update:**
- **ai/STATUS.md** — Current state, what worked/didn't, active work, blockers
- **ai/TODO.md** — Remove completed, add new, update in-progress

**If changes this session:**
- **ai/DECISIONS.md** — New architectural decisions
- **ai/KNOWLEDGE.md** — Codebase quirks discovered
- **ai/PLAN.md** — Phase changes, major pivots
- **ai/RESEARCH.md** — New research findings (index only, details → ai/research/)

## 3. Health Check

| Issue | Fix |
|-------|-----|
| Session files >500 lines | Prune historical content, move details to subdirs |
| Completed tasks in TODO.md | Delete them (trust git) |
| WEEK*.md or time-tracking files | Consolidate to STATUS.md, delete files |
| Stale content in STATUS.md | Remove old blockers, completed phases |

## 4. Commit

```bash
git add ai/
git commit -m "Update ai/ context"
```

## 5. Report

```
ai/ updated
- STATUS.md: [state summary]
- TODO.md: [N pending, N in-progress]
- Committed: [yes/no]

Next: /compact to compress conversation
```
