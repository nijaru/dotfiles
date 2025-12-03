---
name: context-save
description: >
  Updates ai/ directory context files to persist session knowledge.
  Triggers on: "save context", "update status", "end of session",
  "let's wrap up", or when significant progress has been made.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(command:git*)
---

# Context Save Skill

Persist session progress to `ai/` directory files for future sessions.

## Activation Triggers

- Explicit: "update ai/", "update beads", "save context", "sync"
- Task complete: "close the bead", "mark it done", "that's finished"
- End of session: "let's wrap up", "done for today", "stopping here"
- Context switch: "switching to X", "moving on to", "different project"
- After code-review completes and changes are ready to commit

## Files to Update

### 1. STATUS.md (Always)

Current state snapshot. Answer: "What's implemented vs not?"

```markdown
# Status

## Implemented

- [x] Feature A - working
- [x] Feature B - working

## In Progress

- [ ] Feature C - blocked on X

## Not Started

- [ ] Feature D
```

### 2. DECISIONS.md (When decisions were made)

Record significant technical decisions.

```markdown
## [Date] Decision Title

**Context**: What problem we faced
**Decision**: What we chose
**Rationale**: Why (tradeoffs considered)
```

### 3. DESIGN.md (When architecture changed)

Update architecture documentation. No status markers (✅/❌) — that's for STATUS.md.

### 4. Beads (When tasks changed)

```bash
# Check current task
bd show <current-bead-id>

# If task complete
bd close <bead-id>

# If new blockers/tasks discovered
bd create "new task" -t task
bd dep add <task> <blocker>

# Always sync at end
bd sync
```

If no beads configured, fall back to ai/TODO.md.

## Process

**Prerequisite**: If code was written, run code-review first. Only save context after LGTM.

1. **Check bead status**: `bd ready` — what's the current task?
2. **Close completed work**: `bd close <id>` if task is done
3. **Update ai/STATUS.md**: Reflect what's implemented now
4. **Record decisions**: Add to DECISIONS.md if any were made
5. **Sync beads**: `bd sync`
6. **Commit together**: `git add . && git commit -m "..."` (code + context)

## Output

```
Context saved:
- STATUS.md: Updated [what changed]
- DECISIONS.md: Added [decision if any]
- [other files if updated]
```

## What NOT to Do

- Don't create files that don't exist unless needed
- Don't add verbose prose — keep it scannable
- Don't duplicate info across files
- Don't add status markers to DESIGN.md
