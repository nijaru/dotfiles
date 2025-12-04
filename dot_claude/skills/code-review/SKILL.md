---
name: code-review
description: >
  Automatically triggers deep code review when context suggests it's needed.
  Activates on: "review this", "is this ready", "check the code", before PR/release,
  or when user asks about code quality.
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

# Code Review Skill

When activated, execute the full `/code-review` command checklist.

## Activation Triggers

- User says: "is this ready?", "review this", "check the code", "what do you think?"
- Before push: "ready to push", "before I push", "lgtm?"
- Before creating a PR or release
- After completing work: "done with this", "finished the feature", "that should do it"
- When user seems uncertain about code quality

## Execution

Run the complete code review as defined in `/code-review`, which includes:

1. **Design & Architecture** - Pattern fit, dependencies, over-engineering
2. **Naming** - Optimize all names (variables, functions, types, files)
3. **Comments** - Remove unnecessary, add WHY where needed
4. **Code Smells** - Long functions, large files, duplication, dead code
5. **Correctness** - Edge cases, error handling, concurrency
6. **Performance** - Allocations, complexity, N+1 queries
7. **Language Idioms** - Rust/Python/Go/TypeScript best practices
8. **Security** - Input validation, secrets, injection vectors
9. **Tests** - Coverage, edge cases, flakiness
10. **Observability** - Logging, error context

## Scope Detection

See `/code-review` for full detection logic. Priority order:

1. User-specified files → those only
2. Feature branch → diff vs main/master
3. On main + has tags → diff vs last tag (solo project)
4. On main + unpushed → diff vs origin/main
5. Staged changes → review staged
6. Unstaged changes → review unstaged

## Output

Use the standard format from `/code-review`:

- Severities: ERROR, WARN, REFACTOR, NIT
- Location: `file:line`
- Summary with verdict: LGTM / LGTM with nits / Needs work
