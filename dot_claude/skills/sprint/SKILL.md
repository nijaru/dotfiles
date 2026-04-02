---
name: sprint
description: Use when a project spec or design doc exists and needs breaking down into demoable sprints and atomic tasks.
allowed-tools: Read, Task, AskUserQuestion
---

# Sprint Planning

Transform project specifications into iterative, demoable sprints and atomic, verifiable tasks.

## Mandates

- **Demoable:** Every sprint MUST result in working, demoable software.
- **Atomic:** Tasks must be single-concern and ideally single-commit.
- **Verifiable:** Every task must have explicit acceptance criteria or tests.

## Standards

### 1. Analysis
Identify core requirements, integration points, and technical risks from the provided spec (`@docs/spec.md`, `DESIGN.md`, etc.).

### 2. Sprint Definition
Structure sprints to build incrementally. Avoid "backend-only" sprints.
- **Index:** `ai/SPRINTS.md` (Status table for all sprints).
- **Sprint Files:** `ai/sprints/NN-name.md` (Detailed task lists).

### 3. Task Specification
| Field | Requirement |
| :--- | :--- |
| **Title** | Short, descriptive, intent-focused. |
| **Depends on** | Explicitly list blocker task IDs. |
| **Criteria** | Verifiable "Definition of Done." |
| **Technical Notes** | Specific code paths or "gotchas." |

## Output Structure

### ai/SPRINTS.md
```markdown
| Sprint | Goal | Status |
| :--- | :--- | :--- |
| [01-auth](sprints/01-auth.md) | End-to-end authentication | active |
```

### ai/sprints/01-auth.md
```markdown
### Task 1: JWT Middleware
**Depends on:** none
**Criteria:** Rejects invalid tokens, extracts user ID, tests pass.
```

## Anti-Rationalization
| Excuse | Reality |
| :--- | :--- |
| "This task is too small to list" | Small tasks are where scope creep hides. |
| "We'll figure out the demo later" | If it's not demoable, it's not a sprint goal. |
