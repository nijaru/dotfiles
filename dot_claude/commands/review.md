---
description: Code review using parallel subagents
allowed-tools: Read, Grep, Glob, Bash, Task
---

Run code review with 3 parallel reviewer subagents:

1. **Detect scope**: User-provided files, or git diff (branch/staged/unstaged)
2. **Launch 3 parallel subagents** via Task tool (`subagent_type: reviewer`):
   - **Correctness**: Logic, edge cases, state, race conditions
   - **Safety**: Security, error handling, input validation, silent failures
   - **Quality**: Design, performance, idioms, naming, smells
3. **Aggregate**: Deduplicate, sort by severity (ERROR → WARN → NIT)
4. **Report**: Summary with file:line references and fixes

For < 50 lines, review directly without subagents.

Output format:

```
## Review Summary
Scope: [files, lines]
Issues: ERROR: X, WARN: X, NIT: X

## Critical
[ERROR] file:line - Issue → Fix

## Important
[WARN] file:line - Issue → Fix

## Verdict
LGTM / LGTM with nits / Needs work
```
