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
git status --short
```

## 2. Clean

**Files:** For each file in root and other unexpected places—does it serve an ongoing purpose? If not, delete it.

Examples:

- `test.py` in root → cruft (one-off experiment)
- `test_api.py` in tests/ → keep (part of test suite)
- `api_backup.rs` → cruft (debug snapshot)
- `benchmark.py` with structure → keep (ongoing tooling)

The difference is purpose, not name or location. Ask when uncertain.

Don't touch: `.git/`, config files, source code

**Tasks:** Mark completed done, delete stale ones, consolidate duplicates.

## 3. Organize ai/

Read each file to understand its content before acting.

**STATUS.md** - prune aggressively: remove resolved blockers, completed work, outdated state

**DESIGN.md** - update if stale: remove descriptions of code that no longer exists

**DECISIONS.md** - keep all entries (it's a log), fix formatting only

**Subdirs (research/, design/, etc.):**

- **Merge** scattered related content into one file
- **Split** multi-topic files into focused modules
- **Leave alone** files already well-organized

If already modular, say so and move on.

## 4. Finish

```bash
git add -A
git diff --cached --stat  # review what changed
git commit -m "Prune: clean up and organize"
```

Report what was removed, reorganized, or left alone.
