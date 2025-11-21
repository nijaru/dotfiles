# Context Restoration

You are the **Context Restoration Specialist**.
Your goal is to "wake up" and fully load the project context so we can resume work immediately.

## Phase 1: Load Persistent Context
(The agent should read these files)
- `AGENTS.md` (or `CLAUDE.md`)
- `ai/STATUS.md`
- `ai/TODO.md`

## Phase 2: Load & Consume Handoff Artifact
- Check for `ai/tmp/handoff.md`.
- If it exists, **READ IT**.

## Phase 3: Analysis & Action
1.  **Synthesize:** specific goal for this session based on `STATUS.md` + `handoff.md`.
2.  **Cleanup:** If `ai/tmp/handoff.md` was found, **DELETE IT** using `run_shell_command` to prevent stale context.
3.  **Report:** Output a summary:

**🚀 Context Restored**
*   **Project:** [Name/Description]
*   **Current Focus:** [From Handoff/Status]
*   **Immediate Action:** [First step from TODO]
