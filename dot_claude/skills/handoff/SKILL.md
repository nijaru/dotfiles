---
name: handoff
description: Use when generating or updating a handoff document to transition the session to another agent or TUI. DO NOT trigger when the user says "read the handoff", "load the handoff", or "here's the handoff"—handle those as plain file reads.
allowed-tools: Bash, Read, Write
---

# Handoff

## Step 1: Determine intent

Check the exact wording before acting:

| User said                                            | Action                                                                                                               |
| :--------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------- |
| "read/load/open the handoff" or "here's the handoff" | Read `./handoff.md` with the Read tool, summarize its contents to the user, and stop. Do NOT generate a new handoff. |
| "update the handoff"                                 | Read `./handoff.md` first, then update it in place.                                                                  |
| `/handoff` invoked or "make/write/create a handoff"  | Generate or overwrite `./handoff.md`. Proceed below.                                                                 |
| Ambiguous                                            | Default to generating. If the user wanted to read it, they would say so.                                             |

## Step 2: Generate (if applicable)

**1. Gather context:**

- Run `tk ls` to check task state
- Run `git log --oneline -20` for recent commits
- Note any active `jb` background jobs

**2. Write `./handoff.md` first.** This is the primary deliverable—complete it before syncing anything else. If context runs out, the next agent still has a usable handoff:

1. **Status** — What was achieved this session
2. **Context** — Key files changed, patterns introduced, bugs fixed
3. **Decisions** — Context → Decision → Rationale for any architectural choices
4. **Next Steps** — 2-4 atomic, actionable bullets for the incoming agent
5. **Environment** — Active background jobs, env vars, or other session state

**3. Then sync persistent state** so the next agent's supporting context is also current:

- Update `ai/STATUS.md` with current focus, blockers, and any new findings
- Run `tk done` / `tk log` to flush completed work and discoveries into task state
- Update `ai/DESIGN.md` or `ai/DECISIONS.md` if architectural choices were made this session

## Lifecycle

`handoff.md` is a temporary baton—not a permanent artifact. Do NOT commit it unless explicitly asked.

## Anti-patterns

| Mistake                                         | Correction                                                  |
| :---------------------------------------------- | :---------------------------------------------------------- |
| Generating a new handoff when asked to read one | Read the file; do not regenerate                            |
| Skipping `ai/` and task sync                    | Next agent loads stale state—sync after writing the handoff |
| Committing `handoff.md`                         | Ephemeral by design—only commit if explicitly asked         |
