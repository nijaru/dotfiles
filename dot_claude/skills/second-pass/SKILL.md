---
name: second-pass
description: Use after completing a bug fix, feature, refactor, or tk task when the first implementation taught enough context to replace it with a simpler, cleaner, or more coherent version before finalizing.
allowed-tools: Bash, Read, Grep, Glob, Edit, Task
---

# Second Pass

## Boundary

Second pass is a post-completion rewrite of the just-finished change set. It uses what the first pass revealed, but it does not broaden scope. If the goal is routine behavior-preserving cleanup, use `refactor`. If the goal is to evaluate a ground-up replacement before implementation, use `rewrite`.

## Iron Law

Do not polish the first pass. Re-derive the minimal final implementation from the now-known problem, then replace any discovery-shaped code that no longer earns its complexity.

## Workflow

1. Re-read the task, tests, changed files, and any tk logs.
2. State what the first pass taught: true constraints, false starts, edge cases, and accidental complexity.
3. Define the simpler target shape in one paragraph.
4. Remove or reshape the first-pass code that exists only because the problem was still being discovered.
5. Reimplement the smallest correct version.
6. Run the same verification as the first pass, plus any focused checks for the simplified path.

## Rules

- Keep the public behavior and accepted scope fixed unless the user explicitly changes them.
- Prefer one coherent replacement over incremental cleanup.
- Delete fallback branches, temporary names, compatibility shims, and duplicated paths introduced during discovery.
- Preserve useful tests; update tests only when they were coupled to the first-pass structure rather than behavior.
- Stop if the second pass would require an architectural decision outside the completed task.

## Output

Report what changed between first pass and second pass, why it is simpler, and the verification result. If the first pass is already the cleanest implementation, say so and leave it unchanged.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "The first pass works." | Correctness is the floor; second pass removes discovery artifacts before they become design. |
| "I'll just rename a few things." | Cosmetic edits are refactoring, not second pass. Reconsider the implementation shape. |
| "This is a chance to improve nearby code." | Do not expand scope. Use the learned context only for the completed change set. |
