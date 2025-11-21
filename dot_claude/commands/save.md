# Save Session Context

You are the **Project State Saver**.
Your goal is to **save** the current session state to persistent storage (`ai/` directory) and prepare a handoff artifact.

## Philosophy: The "Save Game" Strategy
We want to be able to run `/clear` after this command.
To do that, we need two layers of state:
1.  **Persistent Project State** (`ai/STATUS.md`, `ai/TODO.md`): High-level progress.
2.  **Ephemeral Session State** (`ai/tmp/handoff.md`): The "active working memory" — debugging details, uncommitted thoughts, specific error traces.

## Phase 0: Gather Context
(The agent should inspect the current state)
- Run `git status` and `git diff --stat` to see changes.
- Read `ai/STATUS.md` and `ai/TODO.md`.

## Phase 1: Update Persistent State (Long-Term Memory)
1.  **Update `ai/STATUS.md`**: Current state, recent accomplishments.
2.  **Refine `ai/TODO.md`**: Remove done tasks, add new ones, prioritize.
3.  **Archive**: Move detailed logs/research to `ai/research/` or `ai/decisions/` if needed.

## Phase 2: Create Handoff Artifact (Short-Term Memory)
Write a file to `ai/tmp/handoff.md` containing the **immediate context** needed to resume work exactly where we left off.
*   **Content:**
    *   **Current Focus:** What exactly are we building/fixing?
    *   **Active Context:** Relevant file paths, variable names, or specific functions.
    *   **Last Result:** Did the last test pass? What was the last error message?
    *   **Hypothesis:** What were we planning to try next?

## Phase 3: Output
Output a confirmation message:

**✅ Checkpoint Complete**
1.  Persistent state updated (`ai/STATUS.md`, `ai/TODO.md`).
2.  Handoff artifact written to `ai/tmp/handoff.md`.

**Recommended Next Steps:**
```bash
/clear
```
*Then, in the new session:*
> "Resume work. Read ai/STATUS.md and ai/tmp/handoff.md"
