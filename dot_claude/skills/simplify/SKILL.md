---
name: simplify
description: Use when reviewing or refining recently written or modified code for clarity, consistency, and maintainability — without changing behavior. Trigger after implementing a feature, fixing a bug, or completing a logical chunk of work.
allowed-tools: Read, Grep, Glob, Edit, Bash
---

# Simplify

Review recently modified code and apply targeted refinements that improve clarity and consistency without altering behavior.

## Scope

Focus on code touched in the current session unless explicitly told otherwise.

## Rules

**Preserve functionality** — never change what the code does. All original behavior must remain intact.

**Clarity over brevity** — explicit code is better than compact code. Avoid:

- Nested ternaries (prefer if/else or match/switch)
- Dense one-liners that obscure intent
- Clever tricks that require a comment to explain

**Follow project conventions** — read CLAUDE.md / AGENTS.md for language-specific patterns, naming, and formatting before making changes.

**Don't over-simplify** — avoid:

- Removing helpful abstractions
- Merging unrelated concerns into one function
- Making code harder to debug or extend
- Eliminating structure in the name of "fewer lines"

## Process

1. Identify recently modified files and functions
2. Check CLAUDE.md / AGENTS.md for project-specific standards
3. Look for: unnecessary complexity, redundant code, unclear names, inconsistent style
4. Apply targeted edits — one concern at a time
5. Verify: run tests or linter if available to confirm behavior is unchanged

## What to fix

| Signal                                                           | Fix                                  |
| :--------------------------------------------------------------- | :----------------------------------- |
| Function > 40 lines                                              | Split at natural boundaries          |
| Nesting > 3 deep                                                 | Early returns, guard clauses         |
| Variable name is a single letter or abbreviation (outside loops) | Rename to express intent             |
| Same logic in 2+ places                                          | Extract to a shared function         |
| Comment explains what (not why)                                  | Delete the comment, clarify the code |
| Dead code, unused variables                                      | Delete                               |
| Inconsistent style vs surrounding code                           | Normalize                            |

## What NOT to change

- Logic, behavior, or outputs — even if you think there's a better algorithm
- APIs or public interfaces without asking
- Code outside the recently modified scope
- Passing tests — don't break green

## Subagent dispatch

When the scope is large or you want isolation, spawn a `developer` subagent with:

```
Task: Simplify recently modified code in [file(s)]
Scope: Only code touched in this session
Constraint: Preserve all existing behavior. Follow CLAUDE.md conventions.
Files changed: [list]
```
