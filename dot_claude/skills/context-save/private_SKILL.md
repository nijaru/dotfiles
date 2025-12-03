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

- User says: "update ai/", "update ai/ and beads", "save context", "save progress"
- End of session: "let's wrap up", "that's all for now", "done for today"
- After completing significant work (major feature, refactor, decision)
- Before switching to a different task/project

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

### 4. TODO.md or Beads (When tasks changed)

If using beads: `bd sync`
If using TODO.md: Update task list

## Process

1. **Read current files**: Check what exists in `ai/`
2. **Identify changes**: What was accomplished this session?
3. **Update minimally**: Only change what's stale
4. **Keep it concise**: Tables/lists, not prose
5. **Commit if appropriate**: `git add ai/ && git commit -m "Update project context"`

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
