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

**Files:** For each file in root and other unexpected places—does it serve an ongoing purpose?

- **No purpose** → delete it
- **Has purpose, wrong location** → move to proper place (tests/, scripts/, etc.)
- **Has purpose, right location** → keep

Examples:

- `test.py` in root, throwaway → delete
- `test.py` in root, useful test → move to tests/
- `debug.sh` worth keeping → move to scripts/
- `benchmark.py` with structure → keep (ongoing tooling)

The difference is purpose, not name. Ask when uncertain.

Don't touch: `.git/`, config files, source code

**Tasks:** Mark completed done, delete stale ones, consolidate duplicates.

## 3. Organize ai/

Goal: hierarchical organization where agents can find any topic easily.

- **Overview docs** at top level for high-level context
- **Detailed docs** split out by specific topic
- **One doc per topic** - no scattered duplicates

Read each file to understand its content before acting.

**Root files:**

- STATUS.md - prune aggressively (resolved blockers, completed work, outdated state)
- DESIGN.md - update if stale (remove descriptions of deleted code)
- DECISIONS.md - keep all entries (it's a log)
- SPRINTS.md - update sprint status

**Subdirs (research/, design/, sprints/, etc.):**

- Consolidate scattered content on same topic into one file
- Split multi-topic files into focused single-topic docs
- Leave alone if already well-organized

Preserve all important content. Delete old files only after content is safely moved. If already well-organized, say so and move on.

## 4. Finish

```bash
git add -A
git diff --cached --stat  # review what changed
git commit -m "Prune: clean up and organize"
```

Report what was removed, reorganized, or left alone.
