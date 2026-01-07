---
name: run-review
description: >
  Code review using parallel subagents for correctness, safety, and quality.
  Triggers on: "review", "review this", "check this", "look this over", "is this ready",
  "ready to push", "LGTM?", "before I push", "before I commit", "before the PR",
  "can you check", "does this look right", "anything wrong with this",
  "sanity check", "code check", "review my changes", "what do you think".
  Use when code quality is uncertain or after implementing features.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Code Review

Code review using 3 parallel subagents. Scope detected automatically.

## Workflow

1. **Detect scope** (see below)
2. **Launch 3 parallel reviewer subagents**
3. **Aggregate findings** by severity, deduplicate
4. **Report summary** with actionable items

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

## Parallel Subagents

Launch all 3 in parallel using Task tool with `subagent_type: reviewer`:

### Agent 1: Correctness

Logic and functional correctness.

- Logic errors, off-by-one, boundary conditions
- Null/undefined handling
- State consistency (partial failures)
- Race conditions (if concurrent)
- Edge cases: empty, max, negative, zero
- Control flow correctness
- Algorithm correctness

### Agent 2: Safety

Security and error handling (defensive thinking).

- Input validation at boundaries
- Hardcoded secrets, credentials
- Injection: SQL, XSS, command, path traversal
- Auth/authz checks
- Sensitive data in logs
- Silent failures, empty catch blocks
- Error propagation (swallowed vs bubbled)
- Fallback behavior hiding problems
- Resource cleanup on error

### Agent 3: Quality

Design, performance, and idioms.

- Fits existing patterns?
- Single responsibility
- Over-engineering (future problems?)
- Code smells: long functions (>40 lines), large files (>400 lines)
- Dead code, unused variables
- Naming: intention-revealing, proportional to scope
- No `_v2`, `_new` suffixes
- Unnecessary allocations (`String` vs `&str`, `Vec` vs `&[T]`)
- O(n²) where O(n) possible
- Blocking I/O in async, N+1 queries
- Language idioms (Rust/Python/Go/TS)

## Subagent Prompt

```
Review code changes for [FOCUS: Correctness | Safety | Quality].

Scope: [diff or files]

Report issues with confidence >= 80%. Format:

[SEVERITY] file:line - Issue
  -> Fix

Severities:
- ERROR: Must fix (bugs, security, silent failures)
- WARN: Should fix (smells, performance)
- NIT: Optional (style, minor)

Be thorough. No false positives. Only flag what you're confident about.
```

## Aggregation

1. Deduplicate (same issue from multiple agents = 1 issue)
2. Sort: ERROR → WARN → NIT
3. Group by file

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

## Quick Review (small changes)

For < 50 lines, review directly without subagents:

- [ ] Logic correct, edge cases handled
- [ ] Errors handled, not swallowed
- [ ] No security issues
- [ ] No debug statements
- [ ] Naming clear
- [ ] Fits existing patterns
