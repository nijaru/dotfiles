---
name: refactor
description: Use when improving existing code structure while preserving behavior; trigger on complex functions, deep nesting, duplication, unclear names, or technical debt that does not require changing the design.
allowed-tools: Bash, Read, Grep, Glob, Edit, Task
---

# Refactor

## Boundary

Refactoring changes the shape of existing code without changing external behavior. If the first implementation is complete but should be replaced with a cleaner second attempt, use `second-pass`. If the current design may be fundamentally wrong, use `rewrite`.

## Mandates

- Preserve behavior unless the user explicitly asks for behavior changes.
- Identify the concrete smell before editing: duplication, unclear names, oversized function, excessive nesting, primitive obsession, dead code, or misplaced responsibility.
- Prefer deletion and simplification over new abstractions.
- Verify with existing tests or focused manual checks.

## Standards

- Split functions over 40 lines when they mix responsibilities.
- Flatten nesting deeper than 3 levels with guard clauses or extracted helpers.
- Replace magic values with named constants only when the meaning is domain-specific.
- Rename for intent; never introduce `_new`, `_old`, `_v2`, or compatibility shims.
- Delete dead code and speculative generality immediately.

## Output

State the behavior-preservation check, the main structural change, and the verification command/result. If no edit is warranted, say what made the current structure acceptable.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "This is working, so structure does not matter." | Working code can still hide bugs and slow future changes. |
| "I'll add a wrapper and migrate later." | Compatibility layers become permanent. Change the interface cleanly or do not change it. |
| "This needs a rewrite." | If behavior and design stay the same, it is a refactor, not a rewrite. |
