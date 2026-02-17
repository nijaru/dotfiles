---
name: review
description: Code review using reviewer subagent.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Code Review

Single reviewer subagent with fresh eyes. Scope detected automatically.

## Workflow

1. **Detect scope** (see below)
2. **Build/test FIRST** — Run tests once in the parent before launching the reviewer. Include test output in the agent prompt. Tell the agent tests already pass.
3. **Launch 1 reviewer subagent** with full checklist
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

## Reviewer Subagent

Launch using Task tool with `subagent_type: reviewer`. One agent covers all three areas — splitting reviewers across the same files wastes tokens on redundant reads and deduplication.

### Checklist

**Correctness:**

- Logic errors, off-by-one, boundary conditions
- Null/undefined handling, state consistency
- Race conditions (if concurrent)
- Edge cases: empty, max, negative, zero

**Safety:**

- Input validation at boundaries
- Hardcoded secrets, credentials
- Injection: SQL, XSS, command, path traversal
- Silent failures, empty catch blocks
- Error propagation (swallowed vs bubbled)
- Resource cleanup on error

**Quality:**

- Fits existing patterns? Single responsibility?
- Over-engineering (future problems?)
- Code smells: long functions (>40 lines), large files (>400 lines)
- Dead code, unused variables
- Naming: intention-revealing, proportional to scope
- Unnecessary allocations (`String` vs `&str`, `Vec` vs `&[T]`)
- O(n^2) where O(n) possible
- Blocking I/O in async, N+1 queries
- Language idioms (Rust/Python/Go/TS)

### Prompt

```
Review code changes for correctness, safety, and quality.

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

## Large Reviews (many files across subsystems)

For reviews spanning multiple subsystems, split by **file area** (frontend vs backend, module A vs module B), not by review type. Each reviewer gets different code, no redundancy.

## Quick Review (small changes)

For < 50 lines, review directly without subagents:

- [ ] Logic correct, edge cases handled
- [ ] Errors handled, not swallowed
- [ ] No security issues
- [ ] No debug statements
- [ ] Naming clear
- [ ] Fits existing patterns
