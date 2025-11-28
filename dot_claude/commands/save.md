Update ai/ and sync beads before /compact or session end.

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
- **ai/DECISIONS.md** — New architectural decisions
- **ai/KNOWLEDGE.md** — Codebase quirks discovered
- **ai/PLAN.md** — Phase changes, major pivots
- **ai/RESEARCH.md** — New research findings (index only, details → ai/research/)

## 4. Health Check

| Issue | Fix |
|-------|-----|
| Session files >500 lines | Prune historical content, move details to subdirs |
| Completed tasks in TODO.md | Delete them (trust git) |
| Stale content in STATUS.md | Remove old blockers, completed phases |

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
- Tasks: [N open in beads / N pending in TODO.md]
- Beads synced: [yes/no/n/a]
- Committed: [yes/no]

Next: /compact or provide follow-up prompt
```
