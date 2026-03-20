---
name: handoff
description: Use when generating or updating a handoff document to transition the session to another agent or TUI. DO NOT trigger when the user says "read the handoff", "load the handoff", or "here's the handoff"—handle those as plain file reads.
allowed-tools: Bash, Read, Write
---

# Handoff

## Step 1: Determine intent

| User said                                            | Action                                                                   |
| :--------------------------------------------------- | :----------------------------------------------------------------------- |
| "read/load/open the handoff" or "here's the handoff" | Read `./handoff.md`, summarize it, and stop. Do NOT generate.            |
| "update the handoff"                                 | Read `./handoff.md` first, then update it in place.                      |
| `/handoff` invoked or "make/write/create a handoff"  | Generate or overwrite `./handoff.md`. Proceed below.                     |
| Ambiguous                                            | Default to generating. If the user wanted to read it, they would say so. |

## Step 2: Generate

Gather context: run `tk ls`, `git log --oneline -20`, note any active `jb` jobs.

Write `./handoff.md` — this is the primary deliverable. If context runs out mid-way, the next agent still has a usable doc:

1. **Status** — What was achieved this session
2. **Context** — Key files changed, patterns introduced, bugs fixed
3. **Decisions** — Context → Decision → Rationale for any architectural choices
4. **Next Steps** — 2-4 atomic, actionable bullets for the incoming agent
5. **Environment** — Active background jobs, env vars, or other relevant session state

## Lifecycle

`handoff.md` is a temporary baton—not a permanent artifact. Do NOT commit it unless explicitly asked.

## Anti-patterns

| Mistake                                         | Correction                                          |
| :---------------------------------------------- | :-------------------------------------------------- |
| Generating a new handoff when asked to read one | Read the file; do not regenerate                    |
| Committing `handoff.md`                         | Ephemeral by design—only commit if explicitly asked |
