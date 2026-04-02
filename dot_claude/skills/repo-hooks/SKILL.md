---
name: repo-hooks
description: Use when setting up, auditing, or troubleshooting repo-local Git hooks, formatter checks, or bootstrap commands across repositories.
allowed-tools: Bash, Read, Grep, Glob, Edit
---

# Repo Hooks

**Iron Law:** The hook formats and re-stages; CI is the backstop — never invert this.

- Read the repo instructions first: `AGENTS.md`, `README`, `Makefile`, CI.
- Prefer repo-local hooks when formatting drift is cheap, deterministic, and repeatable.
- Use a repo-managed `.githooks/` directory with `core.hooksPath` when the repo supports it.
- Add one explicit bootstrap command or target, such as `make hooks`, to enable the hook locally.
- Hook behavior:
  - run fast deterministic format/lint commands
  - if the command changes files, print the file names and re-stage them
  - for formatter hooks, auto-fixing and re-staging is preferred over failing the commit
  - use check-only hooks when you want a pure fail-fast gate instead of mutation
- Keep CI as the final backstop.
- Do not invent hook automation if the repo already has a simpler mechanism.
- Do not use pre-commit hooks for slow, flaky, or non-deterministic checks.
- If the same drift keeps recurring across repos, treat it as a hook/bootstrap problem first, not a CI-only problem.

## Good fit

- Formatter drift that keeps landing in CI
- Cheap, local checks that should fail before commit
- Repos that already have a stable `make fmt` or similar command

## Bad fit

- Network calls
- Long-running tests
- Checks that depend on remote services
- Hooks that would become a second CI pipeline
