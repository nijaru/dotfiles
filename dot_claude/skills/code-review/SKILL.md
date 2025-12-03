---
name: code-review
description: >
  Automatically performs deep code review when context suggests it's needed.
  Triggers on: "review this", "is this ready", "check the code", before PR
  creation, before releases, or when user asks about code quality.
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

# Code Review Skill

Perform thorough code review when the context suggests review is appropriate.

## When to Activate

- User asks "is this ready?", "review this", "check the code"
- Before creating a PR or release
- After significant refactoring
- When user seems uncertain about code quality
- When asked "what do you think?" about code changes

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

End with summary: total issues by severity, overall assessment.
