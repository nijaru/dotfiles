---
description: Deep code review before PR/release - checks quality, style, performance
argument-hint: "[path or branch]"
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

Perform a thorough code review on changes. Scope:

- If on a feature branch: review all changes vs main/master
- If specific files provided: review those files
- Otherwise: review staged/unstaged changes

$ARGUMENTS

## Review Checklist

### 1. Correctness

- Logic errors, edge cases, off-by-one
- Error handling coverage
- Race conditions (if concurrent)

### 2. Code Style (per CLAUDE.md)

- **Naming**: Concise, context-aware, no vague suffixes (\_v2, \_new)
- **Comments**: Only WHY, never WHAT - remove obvious/redundant comments
- **File organization**: Single responsibility, no mixed concerns

### 3. Performance

- Unnecessary allocations (Rust: String vs &str, Vec vs &[T])
- O(n²) where O(n) possible
- Missing caching/memoization opportunities
- Blocking I/O in async contexts

### 4. Idioms (language-specific)

- **Rust**: Proper error handling (anyhow/thiserror), borrowing, no unwrap in prod
- **Python**: Type hints, pathlib over os.path, context managers
- **Go**: Error wrapping, defer cleanup, channel usage
- **TypeScript**: Strict null checks, proper async/await

### 5. Security

- Input validation at boundaries
- No hardcoded secrets
- SQL injection, XSS, command injection vectors

### 6. Tests

- Coverage for new functionality
- Edge cases tested
- No flaky tests

## Output Format

For each issue:

```
[SEVERITY] file:line - Issue description
  → Suggested fix
```

Severities: ERROR (must fix), WARN (should fix), INFO (consider)

End with summary: total issues by severity, overall assessment (LGTM / needs work).
