---
name: handoff
description: Use when transitioning the session to another agent or TUI. Summarizes current state, decisions, and next steps into a `handoff.md` file.
allowed-tools: Bash, Read, Write
---

# Handoff

Prepare the workspace for a seamless transition to a new agent or session.

## 🎯 Mandates

- **Context Preservation:** Capture the essence of the session: what was achieved, what changed, and what's next.
- **handoff.md First:** Always create or update `handoff.md` in the project root or `ai/` directory.
- **Actionable Next Steps:** Be specific about the immediate tasks for the next agent.

## 🏗️ Handoff Structure

The `handoff.md` file must include:

1. **Current Status:** A high-level summary of the session's achievements.
2. **Context:** Key files modified, new patterns introduced, or critical bugs fixed.
3. **Decisions:** Any architectural or design choices made (Context -> Decision -> Rationale).
4. **Next Steps:** 2-4 atomic, actionable bullets for the incoming agent.
5. **Environment:** Any session-specific variables or background processes (like `jb`) that are still relevant.

## 🛠️ Workflow

1. **Summarize:** Analyze the session history and `tk` tasks.
2. **Write:** Generate the `handoff.md` content.
3. **Notify:** Instruct the user to provide this file to the next agent.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "The next agent will figure it out." | Without a handoff, the next agent wastes tokens and time re-exploring. |
| "I'll just update STATUS.md." | `handoff.md` is a focused "baton" for the immediate transition; `STATUS.md` is long-term state. |
