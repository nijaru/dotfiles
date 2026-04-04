---
name: prune
description: Use when cleaning up workspace clutter, organizing the ai/ directory, or removing stale task files. Trigger on root directory sprawl, outdated ai/ documents, or redundant temporary scripts.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Prune (Workspace Hygiene)

## Core Mandates

- **Root Zero:** No temporary files in the project root. Move to `scripts/` or delete.
- **Single Source:** Consolidate scattered `ai/` notes into single-topic documents.
- **Index Integrity:** `ai/README.md` must reflect what actually exists — no dead links, no missing entries.
- **Task Integrity:** Mark completed tasks (`tk done`) and delete duplicates.

## Cleanup Standards

### 1. File Triage

For every file in the root or unexpected locations:

- **No purpose:** Delete immediately.
- **Useful tool:** Move to `scripts/` or `bin/`.
- **Useful test:** Move to `tests/`.
- **Core config:** Keep in root.

### 2. AI Directory Organization

- **Root files:** `README.md` (index), `STATUS.md`, `DESIGN.md`, `DECISIONS.md`, `PLAN.md`.
- **Subdirectories:** `research/`, `design/`, `review/`, `sprints/`, `tmp/`.
- **Topic focus:** One document per topic. Split multi-topic files; consolidate duplicates.
- **Frontmatter:** All topic files in subdirs must have `date`, `summary`, `status` frontmatter.
- **Stale files:** `status: resolved` or `status: stale` → delete, don't archive.
- **Index sync:** After any deletions or consolidations, rebuild `ai/README.md` to match reality.

### 3. DECISIONS.md

- Append-only Log — never delete Log entries.
- If Log exceeds ~20 entries, distill oldest into the Principles section, then remove from Log.
- Never delete the Principles section.

### 4. Task Management

- Mark finished tasks as done: `tk done <id>`.
- Delete stale or irrelevant tasks.
- Update `ai/PLAN.md` sprint status if progress was made.

## Execution Workflow

1. **Survey:** `ls -R ai/`, `tk ls`, `git status --short`.
2. **Triage:** Delete, move, and consolidate files per standards above.
3. **Rebuild index:** Rewrite `ai/README.md` to match what exists. Format: `- [Title](path) — one-line hook`.
4. **Commit:** Stage all changes with `chore(ai): prune workspace`.

## Anti-Rationalization

| Excuse                             | Reality                                                                   |
| :--------------------------------- | :------------------------------------------------------------------------ |
| "I'll clean this up after the PR." | Post-PR cleanup rarely happens; debt starts with "just one temp file."    |
| "I might need this debug script."  | If useful, it belongs in `scripts/` with a descriptive name.              |
| "The ai/ directory is fine as is." | Scattered notes force future agents to waste tokens on redundant content. |
| "I'll keep the file just in case." | Stale files pollute context. Delete resolved work.                        |

## Safe Exclusions

- **NEVER** touch `.git/` or core project configuration files.
- **NEVER** delete source code unless specifically instructed.
- **NEVER** delete DECISIONS.md Log entries — distill into Principles instead.
