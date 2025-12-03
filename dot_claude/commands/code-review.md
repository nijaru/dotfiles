---
description: Deep code review before PR/release - checks quality, style, performance
argument-hint: "[path or branch]"
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

Perform a thorough code review. Scope:

- If on a feature branch: review all changes vs main/master
- If specific files provided: review those files
- Otherwise: review staged/unstaged changes

$ARGUMENTS

---

## Review Checklist

### 1. Design & Architecture

- **Fit**: Does the change integrate well with existing patterns?
- **Location**: Does this belong here, or in a library/separate module?
- **Over-engineering**: Is code more generic than needed? Solving future problems?
- **Single responsibility**: Does each file/class/function do one thing?
- **Dependencies**: New deps justified? Maintained? License compatible? Duplicating existing functionality?

### 2. Naming (Optimize Aggressively)

Names should be **intention-revealing** and **proportional to scope**.

| Check                   | Bad                                 | Good                                         |
| ----------------------- | ----------------------------------- | -------------------------------------------- |
| Reveals intent          | `d`, `data`, `tmp`                  | `daysSinceLastLogin`, `userRecords`          |
| No disinformation       | `accountList` (but it's a Map)      | `accountsById`                               |
| Searchable              | `7`, `4`                            | `MAX_RETRIES`, `DAYS_PER_WEEK`               |
| No vague suffixes       | `Handler2`, `_new`, `_v2`           | `AsyncHandler`, `_batched`                   |
| Proportional to scope   | `userAuthenticationService` (local) | `auth` (local), `UserAuthService` (exported) |
| No redundant context    | `Customer.customerName`             | `Customer.name`                              |
| Booleans read naturally | `flag`, `status`                    | `isEnabled`, `hasAccess`, `canEdit`          |

**Action**: Rename unclear variables, functions, classes, types. Suggest better names.

### 3. Comments (Remove or Improve)

Comments should explain **WHY**, never **WHAT**. Remove comments a human wouldn't write.

| Remove                                     | Keep/Add                                     |
| ------------------------------------------ | -------------------------------------------- |
| `i++ // increment i`                       | `// Skip first element: it's the header row` |
| `// TODO: fix this` (stale)                | `// Workaround for Chrome bug #12345`        |
| `// Added by John 2023`                    | Complex regex/algorithm explanation          |
| Commented-out code                         | Non-obvious business rule rationale          |
| `// Initialize the user service` (obvious) | `// Must init before auth due to dep cycle`  |
| Inconsistent with file's comment style     |                                              |

**Action**: Remove redundant/stale/obvious comments. Match the file's existing comment style.

### 4. Code Smells & Refactoring

Look for these patterns and suggest refactoring:

**Bloaters**

- [ ] Long functions (>40 lines) → Extract methods
- [ ] Large files (>400 lines) → Split into modules
- [ ] Long parameter lists (>4 params) → Use objects/builders
- [ ] Primitive obsession → Create domain types
- [ ] Data clumps (same params together) → Extract class

**Duplication & Dead Code**

- [ ] Duplicate code → Extract shared function
- [ ] Dead code (unused functions/variables) → Delete
- [ ] Speculative generality (unused abstractions) → Delete

**Unnecessary Complexity**

- [ ] Single-use variable that just restates the expression → Inline it
- [ ] Single-use variable that names a concept → Keep it (adds clarity)
- [ ] Defensive try/catch wrapping already-handled internal calls → Remove

**Coupling Issues**

- [ ] Feature envy (method uses another class more than its own) → Move method
- [ ] Inappropriate intimacy (classes know too much about each other) → Refactor
- [ ] God class/function (does too much) → Split responsibilities

**Style Consistency**

- [ ] New code matches existing file's patterns (naming, structure, error handling)
- [ ] Defensive checks match the codebase norm (don't over-validate internal calls)
- [ ] Import organization consistent with file

**Action**: Suggest specific refactorings with before/after examples.

### 5. Correctness & Edge Cases

- Logic errors, off-by-one, null/undefined handling
- Error handling coverage (what can fail?)
- Race conditions, deadlocks (if concurrent)
- Boundary conditions (empty, max, negative)
- State consistency (partial failures, rollbacks)

### 6. Performance

- Unnecessary allocations (Rust: `String` vs `&str`, `Vec` vs `&[T]`)
- O(n²) where O(n) possible
- Missing caching/memoization
- Blocking I/O in async contexts
- N+1 queries (database)
- Unbounded growth (memory leaks, missing limits)
- Hot path optimizations

### 7. Language Idioms

**Rust**

- Proper error handling (`anyhow`/`thiserror`), no `unwrap()` in prod
- Borrowing over cloning, `&str` over `String` where possible
- `impl Trait` for return types, proper lifetimes

**Python**

- Type hints on public APIs
- `pathlib` over `os.path`
- Context managers for resources
- List/dict comprehensions where clearer

**Go**

- Error wrapping with context
- `defer` for cleanup
- Channel usage patterns
- Avoid naked returns

**TypeScript**

- Strict null checks, proper `undefined` handling
- `async`/`await` over raw promises
- Discriminated unions for state
- No `as any` casts to bypass type errors → Fix the types properly

### 8. Security

- Input validation at system boundaries
- No hardcoded secrets (check for API keys, passwords)
- SQL injection, XSS, command injection vectors
- Path traversal vulnerabilities
- SSRF (server-side request forgery)
- Auth/authz checks present
- Sensitive data not logged
- Timing attack vectors (constant-time comparison)

### 9. Tests

- Coverage for new/changed functionality
- Edge cases tested (empty, null, boundary)
- No flaky tests (timing, ordering dependencies)
- Tests are readable and maintainable
- Mocks are appropriate (not over-mocked)
- Test names describe behavior

### 10. Observability

- Appropriate log levels (debug/info/warn/error)
- Errors include context for debugging
- No sensitive data in logs
- Metrics/tracing for critical paths (if applicable)

---

## Output Format

For each issue found:

```
[SEVERITY] file:line - Issue description
  Context: <relevant code snippet if helpful>
  → Suggested fix or refactoring
```

**Severities:**

- **ERROR**: Must fix before merge (bugs, security, correctness)
- **WARN**: Should fix (code smells, performance, maintainability)
- **REFACTOR**: Suggested improvement (naming, structure, idioms)
- **NIT**: Optional polish (style preferences)

---

## Summary

End with:

1. **Issues by severity**: ERROR: X, WARN: X, REFACTOR: X, NIT: X
2. **Key concerns**: Top 2-3 issues if any
3. **Positive notes**: What's done well (per Google guidelines)
4. **Verdict**: LGTM / LGTM with nits / Needs work
