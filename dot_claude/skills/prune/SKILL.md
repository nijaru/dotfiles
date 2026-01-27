---
name: prune
description: Clean up temp files, stale tasks, and organize ai/ directory.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Prune

Remove cruft, consolidate files, tidy project state. Goal: lean, organized, ready for fresh work.

## When to Trigger

- Project feels cluttered
- ai/ files have grown large or redundant
- Many stale/completed tasks lingering
- Before starting major new work
- Explicit: "/prune", "clean up"

## 1. Scan for Cruft

Run in parallel:

```bash
# Temp/generated files in root
ls -la *.tmp *.log *.bak *~ .DS_Store 2>/dev/null
find . -maxdepth 2 -name "*.tmp" -o -name "*.bak" -o -name "*~" 2>/dev/null

# Task state
tk ls

# ai/ file sizes
wc -l ai/*.md 2>/dev/null
ls -la ai/**/* 2>/dev/null
```

## 2. Clean Temp Files

Remove from project root (confirm with user if unsure):

- `*.tmp`, `*.bak`, `*~`
- `.DS_Store`
- `*.log` (unless intentional)
- Empty directories
- Build artifacts not in .gitignore

Do NOT remove:

- Anything in .git/
- Files referenced in code
- User data files

## 3. Prune Tasks

```bash
tk ls
```

For each task:

| State              | Action                               |
| ------------------ | ------------------------------------ |
| Completed long ago | `tk done <id>` if not already        |
| Stale/abandoned    | Ask user: delete or keep?            |
| Duplicate          | Consolidate or delete                |
| Vague/unclear      | Clarify or delete                    |
| Blocked forever    | Note in STATUS.md, consider deleting |

Goal: Only actionable, relevant tasks remain.

## 4. Organize ai/

**Read all ai/ files first**, then:

### STATUS.md

- Remove resolved blockers
- Remove completed work items
- Remove outdated metrics
- Keep only: current state, active blockers, recent decisions

### DESIGN.md

- Remove descriptions of deleted/changed code
- Consolidate duplicate sections
- Update outdated diagrams/flows
- Archive historical design notes to ai/archive/ if valuable

### DECISIONS.md

- Keep all decisions (they're historical record)
- Remove duplicates
- Ensure format: Context → Decision → Rationale

### SPRINTS.md

- Remove completed sprints older than 2 sprints
- Archive to ai/archive/sprints.md if needed
- Keep current + 1 previous sprint

### Subdirectories (research/, design/, tmp/)

- Delete tmp/ contents
- Consolidate research/ if >5 files
- Remove outdated design/ files

### File Size Targets

| File         | Target     | Action if exceeded      |
| ------------ | ---------- | ----------------------- |
| STATUS.md    | <100 lines | Prune aggressively      |
| DESIGN.md    | <300 lines | Move details to subdirs |
| DECISIONS.md | <200 lines | Archive old decisions   |
| SPRINTS.md   | <150 lines | Archive old sprints     |

## 5. Consolidate

Look for:

- Multiple files covering same topic → merge
- Scattered notes → collect into appropriate file
- Orphaned files → delete or integrate

## 6. Commit

```bash
git add -A
git status
git commit -m "Prune: clean up temp files and organize ai/"
```

## 7. Report

```
## Pruned

Temp files:
- Removed: [list or count]

Tasks:
- Closed: [N]
- Deleted: [N]
- Remaining: [N]

ai/:
- STATUS.md: [X lines → Y lines]
- DESIGN.md: [updated/unchanged]
- Archived: [list files moved]
- Deleted: [list files removed]

Committed: [yes/no]
```
