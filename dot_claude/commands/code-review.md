---
description: Deep code review - checks quality, style, security, performance
argument-hint: "[path or branch]"
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

Thorough code review. Scope determined by context:

$ARGUMENTS

---

## Scope Detection

Detect automatically (priority order):

```bash
# 1. User provided specific files/paths? → Review those only

# 2. On feature branch?
git branch --show-current  # not main/master → diff vs main

# 3. On main, has upstream remote? (fork pattern)
git remote get-url upstream 2>/dev/null  # → diff vs upstream/main

# 4. On main, has version tags? (solo project)
git describe --tags --abbrev=0 2>/dev/null  # → diff vs last tag

# 5. On main, has unpushed commits?
git log origin/main..HEAD --oneline  # → diff vs origin/main

# 6. Has staged changes? → review staged
git diff --cached --stat

# 7. Has unstaged changes? → review unstaged
git diff --stat

# 8. Nothing to review → inform user
```

---

## Review Checklist

### 1. Design & Architecture

- **Fit**: Integrates with existing patterns?
- **Location**: Belongs here or in library/separate module?
- **Over-engineering**: More generic than needed? Solving future problems?
- **Single responsibility**: Each file/class/function does one thing?
- **Dependencies**: New deps justified? Maintained? License compatible?

### 2. Naming

Names: **intention-revealing**, **proportional to scope**.

| Check             | Bad                       | Good                     |
| ----------------- | ------------------------- | ------------------------ |
| Reveals intent    | `d`, `data`, `tmp`        | `daysSinceLastLogin`     |
| No disinformation | `accountList` (but Map)   | `accountsById`           |
| Searchable        | `7`, `4`                  | `MAX_RETRIES`            |
| No vague suffixes | `_new`, `_v2`             | `_batched`, `_async`     |
| Proportional      | `userAuthService` (local) | `auth` (local)           |
| Booleans          | `flag`, `status`          | `isEnabled`, `hasAccess` |

### 3. Comments

Comments explain **WHY**, never **WHAT**.

| Remove                 | Keep                         |
| ---------------------- | ---------------------------- |
| `i++ // increment i`   | `// Skip header row`         |
| `// TODO: fix` (stale) | `// Workaround for bug #123` |
| Commented-out code     | Complex algorithm rationale  |
| Obvious explanations   | Non-obvious business rules   |

### 4. Debug & Cleanup

Check for leftover artifacts:

```bash
# Debug statements
grep -rn "console\.log\|println!\|print(\|dbg!\|debugger" --include="*.ts" --include="*.rs" --include="*.py"

# Stale TODOs (check if still relevant)
grep -rn "TODO\|FIXME\|XXX\|HACK" --include="*.ts" --include="*.rs" --include="*.py"
```

- [ ] No debug statements in production code
- [ ] TODOs are tracked or removed
- [ ] No commented-out code blocks

### 5. Code Smells

**Bloaters**

- [ ] Long functions (>40 lines) → Extract
- [ ] Large files (>400 lines) → Split
- [ ] Long param lists (>4) → Use objects
- [ ] Primitive obsession → Domain types

**Dead Code**

- [ ] Unused functions/variables → Delete
- [ ] Speculative generality → Delete
- [ ] Duplicate code → Extract

**Coupling**

- [ ] Feature envy → Move method
- [ ] God class → Split responsibilities

**Consistency**

- [ ] Matches file's existing patterns
- [ ] Import organization consistent

### 6. Correctness

- Logic errors, off-by-one
- Null/undefined handling
- Error handling coverage
- Race conditions (if concurrent)
- Boundary conditions (empty, max, negative)
- State consistency (partial failures)

### 7. Performance

- Unnecessary allocations (`String` vs `&str`, `Vec` vs `&[T]`)
- O(n²) where O(n) possible
- Missing caching
- Blocking I/O in async
- N+1 queries
- Unbounded growth

### 8. Language Idioms

**Rust**: `anyhow`/`thiserror`, no `unwrap()` in prod, borrowing over cloning
**Python**: Type hints, `pathlib`, context managers, comprehensions
**Go**: Error wrapping, `defer`, no naked returns
**TypeScript**: Strict nulls, `async`/`await`, no `as any` casts

### 9. Security

- Input validation at boundaries
- No hardcoded secrets
- Injection vectors (SQL, XSS, command, path traversal)
- Auth/authz checks
- Sensitive data not logged
- Timing attacks (constant-time comparison)

### 10. Tests

- Coverage for changes
- Edge cases (empty, null, boundary)
- No flaky tests
- Test names describe behavior
- Not over-mocked

---

## Output Format

```
[SEVERITY] file:line - Issue
  → Suggested fix
```

**Severities:**

- **ERROR**: Must fix (bugs, security)
- **WARN**: Should fix (smells, performance)
- **REFACTOR**: Improvement (naming, structure)
- **NIT**: Optional (style)

---

## Summary

1. **Issues**: ERROR: X, WARN: X, REFACTOR: X, NIT: X
2. **Key concerns**: Top 2-3 issues
3. **Positives**: What's done well
4. **Verdict**: LGTM / LGTM with nits / Needs work
