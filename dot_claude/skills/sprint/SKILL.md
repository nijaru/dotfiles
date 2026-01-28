---
name: sprint
description: Use when a project has a spec/design doc and needs sprint planning with atomic tasks
---

# Sprint Planning

Break project specs into sprints and atomic tasks suitable for iterative development.

## When to Use

- Project has a spec, PRD, or design document
- Need to plan implementation in sprints
- Want atomic, commitable tasks with clear validation

## Input

Provide the spec file path: `@docs/spec.md`, `@DESIGN.md`, etc.

## Process

### 1. Analyze the Spec

Read the spec thoroughly. Identify:

- Core features and requirements
- Dependencies between components
- Technical risks and unknowns
- Integration points

### 2. Break Into Sprints

Each sprint must result in **demoable software** that:

- Can be run and tested independently
- Builds on previous sprints
- Delivers visible progress

### 3. Define Atomic Tasks

Every task/ticket must be:

- **Atomic**: Single commit, single concern
- **Testable**: Has tests OR clear validation criteria
- **Independent**: Can be worked on without blocking others (where possible)
- **Clear**: Technical enough that implementation path is obvious

### 4. Task Format

```markdown
## Task: [Short descriptive title]

**Depends on:** [task IDs or "none"]

### Description

[What needs to be built/changed]

### Acceptance Criteria

- [ ] [Specific, verifiable criterion]
- [ ] [Tests pass / validation method]

### Technical Notes

[Implementation hints, gotchas, relevant code paths]
```

### 5. Review with Subagent

After drafting, spawn a reviewer subagent:

```
Review this sprint plan for:
- Missing edge cases or requirements from the spec
- Tasks that are too large (should be split)
- Tasks that are too small (should be combined)
- Unclear acceptance criteria
- Missing dependencies
- Sprint goals that aren't demoable
```

Incorporate feedback, then write final plan.

### 6. Output Structure

Create two things:

**Index file** `ai/SPRINTS.md`:

```markdown
# Sprint Plan: [Project Name]

Source: [spec file path]
Generated: [date]

| Sprint                        | Goal                | Status  |
| ----------------------------- | ------------------- | ------- |
| [01-auth](sprints/01-auth.md) | User authentication | active  |
| [02-api](sprints/02-api.md)   | Core API endpoints  | pending |
| [03-ui](sprints/03-ui.md)     | Frontend components | pending |
```

**Individual sprint files** `ai/sprints/NN-name.md`:

```markdown
# Sprint 01: Auth

Goal: User authentication working end-to-end

## Tasks

### Task 1: Add JWT middleware

**Depends on:** none

**Description:** Add JWT validation middleware to /api routes

**Acceptance Criteria:**

- [ ] Middleware rejects invalid tokens
- [ ] Middleware extracts user ID
- [ ] Tests pass

### Task 2: ...
```

### 7. Updating Sprints

When a sprint completes:

1. Update status in `ai/SPRINTS.md` index
2. Mark tasks complete in the sprint file
3. Set next sprint to `active`

## Common Mistakes

| Mistake                            | Fix                                                     |
| ---------------------------------- | ------------------------------------------------------- |
| Tasks too vague ("implement auth") | Be specific ("add JWT middleware to /api routes")       |
| No validation criteria             | Every task needs tests or explicit verification         |
| Sprints aren't demoable            | Each sprint = working software, not just "backend done" |
| Missing dependencies               | Map what blocks what before finalizing order            |
| Skipping review                    | Always have subagent review - catches blind spots       |
