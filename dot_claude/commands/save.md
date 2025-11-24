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

**ai/STATUS.md** — Update to reflect current state:
- Current metrics (if any)
- What worked / what didn't
- Active work summary
- Blockers

**ai/TODO.md** — Sync with actual progress:
- Remove completed tasks
- Add new tasks discovered
- Update in-progress items

**ai/DECISIONS.md** — Add any new decisions made this session (if applicable).

**ai/KNOWLEDGE.md** — Add any codebase quirks discovered (if applicable).

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
