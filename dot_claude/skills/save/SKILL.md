---
name: save
description: Use when persisting session state, updating AI context documents (ai/), and managing task progress (tk). Trigger before context compacting, session termination, or after completing a significant task.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Save (Context Persistence)

## 🎯 Core Mandates

- **Volatile Context:** Never assume state persists across sessions. Write every finding, blocker, and decision to `ai/` or `tk`.
- **Log First:** Update `tk log <id>` with technical root causes and file paths BEFORE marking a task as `done`.
- **Pruning:** Keep `STATUS.md` and other `ai/` documents compact (<500 lines). Delete outdated state aggressively.
- **Next Steps:** Always define the "2-4 bullets" of what to do next to guide the following agent.

## 🛠️ Persistence Standards

### 1. Task Management (`tk`)
- **Review:** Run `tk ls` to identify active and stale tasks.
- **Log:** Record specific technical findings: `tk log <id> "Root cause: race condition in store.go:142"`.
- **Done:** Close completed tasks immediately.
- **Add:** Create atomic, actionable tasks for any remaining work.

### 2. AI Context (`ai/`)
- **STATUS.md:** Update current focus, active blockers, and what worked.
- **DESIGN.md:** Reflect any changes to components, interfaces, or architectural patterns.
- **DECISIONS.md:** Log new technical decisions using the `Context -> Decision -> Rationale` format.
- **SPRINTS.md:** Ensure sprint progress reflects the reality of the codebase.

### 3. Source Control
Always commit context updates to ensure they are tracked:
```bash
git add ai/ .tasks/
git commit -m "chore: save session context"
```

## 📋 Reporting Format

```markdown
## Context Saved

- **Tasks:** [N done, N added, N pending]
- **AI Docs:** [Summary of updates to STATUS, DESIGN, etc.]

## Next Steps (Transition Plan)

1. [Actionable bullet]
2. [Actionable bullet]
3. [Actionable bullet]
```

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "The git commit message is enough." | Commits track code; `ai/` tracks intent, logic, and the future plan. |
| "I'll update the status later." | Without immediate updates, context is lost during the next session swap or compaction. |
| "I don't need to log findings." | Future agents will waste time re-discovering what you already learned. |

## 🛠️ Troubeshooting

- **Task Bloat:** If `tk ls` is overwhelmed, consolidate tasks into a new sprint in `ai/sprints/`.
- **Doc Sprawl:** If `STATUS.md` exceeds 500 lines, move historical data to `ai/research/` or `ai/archive/`.
