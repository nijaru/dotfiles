---
name: review
description: >
  Code review for quality, style, security, performance.
  Triggers on: "review", "check this", "is this ready", "LGTM?", "before I push",
  before PR/commit, or when code quality is uncertain.
metadata:
  short-description: Thorough code review
---

# Code Review

Thorough code review. Scope detected automatically.

## Triggers

- "review this", "check this code", "look this over"
- "is this ready?", "ready to push?", "LGTM?"
- "before I commit", "before the PR"
- User uncertain about code quality

## Scope Detection

Detect automatically (priority order):

1. User provided specific files/paths? -> Review those only
2. On feature branch? -> diff vs main
3. Has staged changes? -> review staged
4. Has unstaged changes? -> review unstaged
5. Nothing to review -> inform user

## Review Checklist

### 1. Design & Architecture

- **Fit**: Integrates with existing patterns?
- **Over-engineering**: More generic than needed?
- **Single responsibility**: Each file/class/function does one thing?

### 2. Naming

Names: **intention-revealing**, **proportional to scope**.

| Check             | Bad                | Good                     |
| ----------------- | ------------------ | ------------------------ |
| Reveals intent    | `d`, `data`, `tmp` | `daysSinceLastLogin`     |
| No vague suffixes | `_new`, `_v2`      | `_batched`, `_async`     |
| Booleans          | `flag`, `status`   | `isEnabled`, `hasAccess` |

### 3. Comments

Comments explain **WHY**, never **WHAT**.

### 4. Code Smells

- Long functions (>40 lines) -> Extract
- Large files (>400 lines) -> Split
- Long param lists (>4) -> Use objects
- Unused code -> Delete

### 5. Correctness

- Logic errors, off-by-one
- Null/undefined handling
- Error handling coverage
- Boundary conditions

### 6. Performance

- Unnecessary allocations
- O(n²) where O(n) possible
- N+1 queries

### 7. Security

- Input validation at boundaries
- No hardcoded secrets
- Injection vectors (SQL, XSS, command)

## Output Format

```
[SEVERITY] file:line - Issue
  -> Suggested fix
```

**Severities:**

- **ERROR**: Must fix (bugs, security)
- **WARN**: Should fix (smells, performance)
- **REFACTOR**: Improvement (naming, structure)
- **NIT**: Optional (style)

## Summary

1. **Issues**: ERROR: X, WARN: X, REFACTOR: X, NIT: X
2. **Key concerns**: Top 2-3 issues
3. **Positives**: What's done well
4. **Verdict**: LGTM / LGTM with nits / Needs work
