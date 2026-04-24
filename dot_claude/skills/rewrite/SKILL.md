---
name: rewrite
description: Use when evaluating whether a project, feature, module, or component should be replaced by a ground-up design before implementation; trigger when incremental fixes seem structurally inadequate.
allowed-tools: Bash, Read, Grep, Glob, Write, WebSearch, Agent
---

# Rewrite

## Boundary

Rewrite is an investigation, not an implementation. It asks whether the current design should be replaced and what the replacement would look like. If behavior should stay the same, use `refactor`. If a completed first pass should be redone with better hindsight, use `second-pass`.

## Mandates

- Start from the problem, not the current implementation.
- Audit before designing: separate fundamentally wrong abstractions from incidental mess.
- Verify whether old constraints still hold before using them to justify the current design.
- Research current best practice when the problem has external reference implementations or library support.
- Present the rewrite case; do not begin implementation unless the user explicitly approves.

## Workflow

1. Audit current state and classify what is fundamentally broken, incidentally broken, and worth keeping.
2. Check constraints: performance, scale, compatibility, integrations, runtime, language, and ecosystem assumptions.
3. Research current approaches if the domain has useful external precedents.
4. Sketch the ideal design: data model, API surface, control flow, failure modes, and migration implications.
5. Compare gaps: what refactoring can fix vs. what only a replacement can fix.

## Rewrite Signals

| Signal | Implication |
| :--- | :--- |
| Core data model does not match the problem | Strong rewrite case |
| Correctness requires breaking the public API | Strong rewrite case |
| Performance requires a different algorithm or ownership model | Strong rewrite case |
| Complexity is mostly duplicated or poorly named code | Refactor instead |
| First pass works but is discovery-shaped | Second-pass instead |

## Output

Report the current-state verdict, constraint check, ideal design sketch, gap analysis, and rewrite case. Save to `ai/design/<feature>.md` only when the project uses `ai/` context and the result will guide future work.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I already know it needs a rewrite." | Prove the current design is structurally wrong before replacing it. |
| "We can decide while implementing." | Rewrite decisions are design decisions; investigate first. |
| "This is just a big refactor." | If the data model, API, or architecture changes, call it a rewrite investigation. |
