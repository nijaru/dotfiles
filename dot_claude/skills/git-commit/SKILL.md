---
name: git-commit
description: Use when writing git commit messages to enforce consistent format and quality.
---

# Git Commit Messages

## Format

```
<type>(<scope>): <description>

[optional body]
```

## Rules (violations are bugs)

- Scope is ALWAYS required — the package, module, tool, or area changed
- Description is imperative mood ("add" not "added", "fix" not "fixed")
- Description starts lowercase
- No period at end of description
- Subject line ≤ 72 characters (50 ideal)
- Body wraps at 72 characters
- Body explains WHY, not what (the diff shows what)

## Allowed Types

| Type       | When to use                        |
| ---------- | ---------------------------------- |
| `feat`     | User-visible new capability        |
| `fix`      | Bug fix                            |
| `refactor` | Behavior-preserving restructure    |
| `perf`     | Performance improvement            |
| `test`     | Adding/updating tests only         |
| `docs`     | Documentation only                 |
| `build`    | Dependencies, build tooling        |
| `ci`       | CI/CD configuration                |
| `chore`    | None of the above (use sparingly)  |

## Scope Guide

- Use the narrowest meaningful area: `pkg/auth`, `cli`, `api/router`, `rust-cli`
- For monorepos: the package or workspace name
- For single-package repos: the top-level directory or feature area
- NEVER use generic scopes: `misc`, `code`, `update`, `files`, `project`

## Examples

```
feat(cli): add export subcommand
fix(pkg/auth): reject expired cached tokens
refactor(api/router): simplify route registration
perf(db): batch inserts in hot path
test(pkg/auth): cover token expiry edge cases
docs(readme): add local dev setup section
build(deps): bump serde to 1.0.200
ci(github): add rust clippy job
chore(scripts): update release helper
```

## Body Use

Add a body when the WHY is non-obvious:

```
fix(db): use prepared statements for hot queries

Parameterized queries were being constructed via string
formatting under high concurrency, causing intermittent
SQL injection surface and connection pool exhaustion.
```

Skip the body when the subject is self-explanatory:

```
test(pkg/auth): cover token expiry edge cases
```

## Anti-patterns

- `feat: add stuff` — scope missing
- `fixed the bug` — not imperative, no scope, no type
- `chore: update code` — meaningless scope
- `refactor(api): refactored the api module` — description restates scope
- Combining unrelated changes in one commit
