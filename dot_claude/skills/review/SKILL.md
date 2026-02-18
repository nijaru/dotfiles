---
name: review
description: Code review with refactoring suggestions — correctness, safety, quality, and structural improvements with before/after examples. Runs a reviewer subagent on detected scope or specified files.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Code Review

Single reviewer subagent with fresh eyes. Covers correctness, safety, quality, and refactoring opportunities with before/after examples.

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

Launch using Task tool with `subagent_type: reviewer`. One agent covers all areas.

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

**Quality & Refactoring:**

- Fits existing patterns? Single responsibility?
- Over-engineering (future problems?)
- Naming: unclear names, `_v2`/`_new` suffixes, magic numbers, inconsistent style
- Size: long functions (>40 lines), large files (>400 lines), deep nesting (>3), many parameters (>4)
- Smells: duplication (3+ lines, 2+ times), feature envy, primitive obsession, dead code, speculative generality
- Structure: god objects, multiple responsibilities — flag with before/after
- Unnecessary allocations (`String` vs `&str`, `Vec` vs `&[T]`)
- O(n^2) where O(n) possible
- Blocking I/O in async, N+1 queries
- Language idioms (Rust/Python/Go/TS)

### Prompt

```
Review code for correctness, safety, and quality. For quality/structural issues, provide before/after examples.

Scope: [diff or files]

Report issues with confidence >= 80%. Format:

Correctness/safety issues:
[SEVERITY] file:line - Issue
  -> Fix

Quality/refactoring issues:
[SEVERITY] file:line - Issue
  Before: [code]
  After: [code]

Severities:
- ERROR: Must fix (bugs, security, silent failures)
- WARN: Should fix (smells, performance, structure)
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
  Before: [code]
  After: [code]

## Minor

[NIT] file:line - Issue
  -> Fix

## Strengths

- What's done well

## Verdict

LGTM / LGTM with nits / Needs work

## Refactoring Plan (if changes warranted)

Priority:
1. [Change] - file:line
2. [Change] - file:line

Risk: [Safe / Needs tests first]

Implement these changes?
```

## Large Reviews (many files across subsystems)

For reviews spanning multiple subsystems, split by **file area** (frontend vs backend, module A vs module B), not by review type.

## Quick Review (small changes)

For < 50 lines, review directly without subagents:

- [ ] Logic correct, edge cases handled
- [ ] Errors handled, not swallowed
- [ ] No security issues
- [ ] No debug statements
- [ ] Naming clear, no structural issues
- [ ] Fits existing patterns
