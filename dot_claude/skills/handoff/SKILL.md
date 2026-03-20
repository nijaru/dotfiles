---
name: handoff
description: Use when transitioning the session to another agent or TUI. Summarizes current state, decisions, and next steps into a `handoff.md` file.
allowed-tools: Bash, Read, Write
---

# Handoff

Prepare the workspace for a seamless transition to a new agent or session.

## Intent Disambiguation

Read conversation context carefully before acting:

- **Skill was invoked (`/handoff`)** → Generate or update `handoff.md`. Do not just read it.
- **User says "read the handoff" / "load the handoff" / "here's the handoff"** → Read `./handoff.md` and internalize it as context for the current session. Do not regenerate it.
- **User says "update the handoff"** → Read the existing `./handoff.md` first, then update it in place.
- **Ambiguous** → Default to generating/updating. If the user wanted to read it, they would say so explicitly.

## 🎯 Mandates

- **Default path:** Always write to `./handoff.md` (project root) unless the user specifies otherwise.
- **Context Preservation:** Capture the essence of the session: what was achieved, what changed, and what's next.
- **Actionable Next Steps:** Be specific about the immediate tasks for the next agent.

## 🏗️ Handoff Structure

The `handoff.md` file must include:

1. **Current Status:** A high-level summary of the session's achievements.
2. **Context:** Key files modified, new patterns introduced, or critical bugs fixed.
3. **Decisions:** Any architectural or design choices made (Context -> Decision -> Rationale).
4. **Next Steps:** 2-4 atomic, actionable bullets for the incoming agent.
5. **Environment:** Any session-specific variables or background processes (like `jb`) that are still relevant.

## 🛠️ Workflow (generating)

1. **Summarize:** Analyze the session history and `tk` tasks.
2. **Write:** Generate or update `./handoff.md`.
3. **Notify:** Tell the user the file is ready and to pass it to the next agent.

## Lifecycle

`handoff.md` is a **temporary baton**—not a permanent artifact. Do NOT commit it unless the user explicitly requests it.

## 🚫 Anti-Rationalization

| Excuse                                   | Reality                                                                                         |
| :--------------------------------------- | :---------------------------------------------------------------------------------------------- |
| "The next agent will figure it out."     | Without a handoff, the next agent wastes tokens and time re-exploring.                          |
| "I'll just update STATUS.md."            | `handoff.md` is a focused "baton" for the immediate transition; `STATUS.md` is long-term state. |
| "I'll commit it for safekeeping."        | Don't—it's ephemeral by design. Only commit if explicitly asked.                                |
| "User invoked /handoff so I'll read it." | Skill invocation means generate/update, not read.                                               |
