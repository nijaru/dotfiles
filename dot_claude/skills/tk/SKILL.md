---
description: Task tracking with tk. Use for multi-step work, cross-session persistence, tracking progress.
allowed-tools: Bash
---

# tk - Task Tracker

Minimal task tracker for AI agents. Plain JSON in `.tasks/`, git-friendly.

## Quick Reference

```bash
tk init                    # Initialize in project
tk add "title"             # Create task
tk add "title" -p 1        # With priority (0-4, 1=urgent)
tk ls                      # List tasks
tk ready                   # Open + unblocked tasks
tk start <id>              # Begin working (open → active)
tk log <id> "message"      # Add progress note
tk done <id>               # Complete task
tk show <id>               # Task details
```

## Extended Commands

```bash
tk add "title" -l bug,urgent      # Labels
tk add "title" --due +7d          # Due date (relative)
tk add "title" --due 2026-01-15   # Due date (absolute)
tk block <id> <blocker-id>        # Add dependency
tk unblock <id> <blocker-id>      # Remove dependency
tk edit <id>                      # Edit task
tk reopen <id>                    # Reopen completed task
tk rm <id>                        # Delete task
tk clean                          # Remove old done tasks
tk check                          # Fix data issues
```

## Workflow

1. **Session start**: `tk ready` → `tk start <id>`
2. **During work**: `tk log <id> "progress note"`
3. **Complete**: `tk done <id>`
4. **New work found**: `tk add "new task"`

## When to Use

- Multi-step tasks
- Cross-session work (persists through compaction)
- Tracking progress on complex features
- Dependencies between tasks

## ID Format

IDs are project-prefixed: `myapp-a7b3`. Use just the ref (`a7b3`) - tk resolves it.
