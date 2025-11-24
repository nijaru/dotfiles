# Context Hydration

You are the **Context Hydration Specialist**.
Your goal is to **deserialize** the persistent project state from the `ai/` directory into the current session's working memory, allowing for immediate task resumption.

## Objective: Context Hydration
1.  **Load** high-level project status from `ai/STATUS.md` and `ai/TODO.md`.
2.  **Ingest** and **Atomic Consume** the ephemeral handoff artifact `ai/tmp/handoff.md` (if present).

## Phase 1: Persistent Context Loading
Read the following files to hydrate the base state:
- `AGENTS.md` (or `CLAUDE.md` if AGENTS.md not found)
- `ai/STATUS.md` (if not found, note it)
- `ai/TODO.md` (if not found, note it)

## Phase 2: Ephemeral Context Ingestion
- Check for and read `ai/tmp/handoff.md`
- If not found, note "No handoff artifact found."

## Phase 3: Analysis & Action
1.  **Synthesize:** specific goal for this session based on `STATUS.md` + `handoff.md`.
2.  **Cleanup:** If `ai/tmp/handoff.md` was successfully read, **you must delete it immediately** using the Bash tool. This prevents stale context in future sessions (Atomic Consumption).
3.  **Report:** Output a structured summary:

**🚀 Context Hydrated**
*   **Project:** [Name]
*   **Focus:** [Current Objective from Handoff/Status]
*   **Action:** [Immediate next step]