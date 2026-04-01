---
name: save
description: Use when persisting session state, updating AI context documents (ai/), and managing task progress (tk). Trigger before context compacting, session termination, or after completing a significant task.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Context (Persistence & Task Management)

## Core Mandates

- **Volatile Context:** Never assume state persists. Write findings, blockers, and decisions to `ai/` or `tk` immediately.
- **Task Lifecycle:** Use `tk start` when beginning, `tk log` for discoveries (with file:line), and `tk done` when finished.
- **High-Signal Logging:** Only log findings in `tk log` that are essential for context recovery.
- **Just-in-Time Documentation:** Keep `ai/` documents compact. Use a flat structure by default.

## Persistence Standards

### 1. Task Management (`tk`)
- **Start:** `tk start <id>` when starting work.
- **Log:** `tk log <id> "finding (with file:line)"`.
- **Done:** Close tasks immediately.
- **Add:** Create atomic, actionable tasks for remaining work.

### 2. AI Context (`ai/`)
- **STATUS.md:** Update current Global Phase, active focus, and what worked.
- **DESIGN.md:** Record architectural decisions ONLY if they deviate from initial plans.
- **DECISIONS.md:** Log high-impact decisions using the `Context -> Decision -> Rationale` format.

### 3. Source Control
- **Commits:** One logical change = one commit.
- **Context files:** Stage and commit `ai/` and `.tasks/` only if they are tracked. Prefer local persistence via `.git/info/exclude`.
