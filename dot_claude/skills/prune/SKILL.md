---
name: prune
description: Clean up temp files, stale tasks, and organize ai/ directory.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Prune

Clean up project cruft. Run when things feel cluttered.

## 1. Survey

```bash
ls -la
ls -la ai/ ai/**/* 2>/dev/null
tk ls
```

## 2. Clean Files

For each file in root and other unexpected places: does it serve an ongoing purpose? If not, delete it.

**Cruft** (no ongoing purpose):

- `test.py` in root - one-off experiment, not part of test suite
- `api_backup.rs` - snapshot from debugging session
- `output.json` - generated artifact, not checked in

**Not cruft** (intentional):

- `test_api.py` in tests/ - part of test suite
- `benchmark.py` with imports and structure - ongoing tooling
- `notes.md` in ai/ - working documentation

The difference is purpose, not name or location. Ask when uncertain.

Don't delete: `.git/`, config files, source code

## 3. Clean Tasks

- Mark completed tasks done
- Delete stale/abandoned tasks (ask if unsure)
- Consolidate duplicates

## 4. Clean ai/

**Prune aggressively:**

- STATUS.md - remove resolved blockers, completed work, outdated state

**Update if stale:**

- DESIGN.md - remove descriptions of code that no longer exists
- DECISIONS.md - keep all entries (it's a log), just fix formatting

**Only archive** content that's truly historical (old sprint records, superseded designs)

## 5. Organize ai/

Goal: modular files that agents can easily find and use.

**Merge** scattered related content into one file

**Split** multi-topic files into focused modules

**Leave alone** files that are already well-organized

If files are already modular, say so and move on.

## 6. Commit

```bash
git add -A
git commit -m "Prune: clean up and organize"
```

## 7. Report

```
## Pruned

Files: [what was removed]
Tasks: [closed/deleted]
ai/: [what changed]
```
