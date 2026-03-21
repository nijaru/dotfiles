---
name: tk
description: Use for all task management, progress tracking, and persisting findings across context compactions.
allowed-tools: Bash, Read, Write, Edit
---

# tk (Task Tracker)

## 🎯 Core Mandates

- **Lifecycle Consistency:** `tk start` when beginning a task, `tk log` for all discoveries, and `tk done` upon completion.
- **Persistence:** Findings MUST be logged via `tk log` to ensure they survive context compaction and are available to future agents.
- **No Stale Tasks:** Update `STATUS.md` and task logs immediately when focus shifts or blockers emerge.

## 🛠️ Technical Standards

### 1. Task Lifecycle
| Stage | Command | Purpose |
| :--- | :--- | :--- |
| **Start** | `tk start <id>` | Move task from `open` to `active`. |
| **Discover** | `tk log <id> "finding"` | Record critical paths, root causes, or decisions. |
| **Block** | `tk block <id> <blocker_id>` | Formally link dependencies. |
| **Complete** | `tk done <id>` | Mark as finished. |

### 2. Logging Strategy
- **Log immediately:** Do not wait for the end of a session.
- **Be specific:** Include file paths, symbol names, and error codes.
- **Decision tracking:** Record WHY a specific approach was chosen over others.

### 3. Management
- `tk ready`: View unblocked, actionable tasks.
- `tk show <id>`: Review full history before starting work.
- `tk mv <id> <project>`: Keep tasks organized by project.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll remember this" | You won't after context compaction. Log it. |
| "It's a small change" | Small changes cause the most regressions. Track them. |
| "Status is in history" | History is ephemeral; `.tasks/` is permanent. |
| "I'll log at the end" | If the session crashes or limits are reached, context is lost. |
