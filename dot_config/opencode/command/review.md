---
description: Code review for correctness, safety, and quality.
---

# Code Review

Review code changes for correctness, safety, and quality.

## Scope Detection

```bash
# Priority order:
# 1. User provided specific files/paths? -> Review those
# 2. Feature branch? -> diff vs main
# 3. Upstream remote? -> diff vs upstream/main
# 4. Version tags? -> diff vs last tag
# 5. Unpushed commits? -> diff vs origin/main
# 6. Staged changes? -> git diff --cached
# 7. Unstaged changes? -> git diff
# 8. Nothing -> inform user
```

## Review Focus

### Correctness

- Logic errors, off-by-one, boundary conditions
- Null/undefined handling
- State consistency (partial failures)
- Race conditions (if concurrent)
- Edge cases: empty, max, negative, zero

### Safety

- Input validation at boundaries
- Hardcoded secrets, credentials
- Injection: SQL, XSS, command, path traversal
- Auth/authz checks
- Sensitive data in logs
- Silent failures, empty catch blocks
- Resource cleanup on error

### Quality

- Fits existing patterns?
- Single responsibility
- Over-engineering (future problems?)
- Code smells: long functions (>40 lines), large files (>400 lines)
- Dead code, unused variables
- Naming: intention-revealing, proportional to scope
- Unnecessary allocations
- O(n^2) where O(n) possible

## Output Format

```
## Review Summary

Scope: [X files, Y lines]
Issues: ERROR: X, WARN: X, NIT: X

## Critical (must fix)

[ERROR] file:line - Issue
  -> Fix

## Important (should fix)

[WARN] file:line - Issue
  -> Fix

## Minor

[NIT] file:line - Issue
  -> Fix

## Strengths

- What's done well

## Verdict

LGTM / LGTM with nits / Needs work
```
