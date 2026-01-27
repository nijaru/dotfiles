---
name: prune
description: Clean up temp files, stale tasks, and organize ai/ directory.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Prune

Clean up project cruft. Run when things feel cluttered.

## 1. Survey the Mess

```bash
# What's in root that might be cruft?
ls -la

# What's in ai/?
ls -la ai/ ai/**/* 2>/dev/null

# Task state
tk ls
```

Look for:

- Test/debug scripts (test.py, debug.sh, scratch._, try\__)
- Temp files (_.tmp, _.bak, \*~, .DS_Store)
- One-off experiments that served their purpose
- Logs, dumps, artifacts not in .gitignore
- Files that don't belong in root

## 2. Clean Files

For each suspicious file: is it still needed? If not, delete it.

Ask user if unsure about anything that looks intentional.

Don't delete: `.git/`, config files, actual source code

## 3. Clean Tasks

- Mark completed tasks done
- Delete stale/abandoned tasks (ask if unsure)
- Consolidate duplicates

## 4. Clean ai/

Read each file, then:

- Remove info that no longer applies (old blockers, completed work, outdated designs)
- Merge overlapping files
- Delete files that serve no purpose
- Move historical content to ai/archive/ if worth keeping

## 5. Commit

```bash
git add -A
git commit -m "Prune: clean up temp files and organize ai/"
```

## 6. Report

```
## Pruned

Files: [what was removed]
Tasks: [closed/deleted]
ai/: [what changed]
```
