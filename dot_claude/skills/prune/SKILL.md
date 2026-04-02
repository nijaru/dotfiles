---
name: prune
description: Use when cleaning up workspace clutter, organizing the ai/ directory, or removing stale task files. Trigger on root directory sprawl, outdated status documents, or redundant temporary scripts.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Prune (Workspace Hygiene)

## Core Mandates

- **Root Zero:** No temporary files in the project root. Move to `scripts/` or delete.
- **Single Source:** Consolidate scattered `ai/` notes into single-topic documents.
- **Aggressive Status:** Prune `STATUS.md` of resolved blockers and completed tasks.
- **Task Integrity:** Mark completed tasks (`tk done`) and delete duplicates.

## Cleanup Standards

### 1. File Triage
For every file in the root or unexpected locations:
- **No purpose:** Delete immediately.
- **Useful tool:** Move to `scripts/` or `bin/`.
- **Useful test:** Move to `tests/`.
- **Core config:** Keep in root.

### 2. AI Directory Organization
- **Top-level:** Keep `STATUS.md`, `DESIGN.md`, and `DECISIONS.md`.
- **Subdirectories:** Group by `research/`, `sprints/`, or `design/`.
- **Topic Focus:** One document per topic. Split multi-topic files; consolidate duplicates.

### 3. Task Management
- Mark finished tasks as `done`.
- Delete stale or irrelevant tasks.
- Ensure `SPRINTS.md` reflects current progress.

## Execution Workflow

1. **Survey:** Run `ls -R`, `tk ls`, and `git status --short`.
2. **Execute:** Delete, move, and consolidate files based on triage standards.
3. **Commit:** Stage all changes and commit with "chore: prune workspace".

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll clean this up after the PR." | Post-PR cleanup rarely happens; technical debt starts with "just one temp file." |
| "I might need this debug script later." | If it's useful, it belongs in `scripts/` with a descriptive name, not in the root. |
| "The ai/ directory is fine as is." | Scattered notes force future agents to waste tokens reading redundant information. |

## Safe Exclusions

- **NEVER** touch `.git/` or core project configuration files.
- **NEVER** delete source code unless specifically instructed.
- **NEVER** delete `DECISIONS.md` entries; it is a permanent log.
