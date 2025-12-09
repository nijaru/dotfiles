---
name: release
description: >
  Auto-triggers release workflow when publish intent detected.
  Activates on: "release", "publish", "tag v", "ship it", "bump version",
  or before cargo publish, npm publish, gh release, uv publish.
allowed-tools: Read, Grep, Glob, Bash
---

# Release Skill

When activated, run `/release` command.

## Triggers

- "release", "publish", "ship", "deploy"
- "tag v", "bump version", "ready to release"
- Before: `cargo publish`, `npm publish`, `gh release`, `uv publish`
- "is it ready to ship?"

## Execution

Run `/release` which will:

1. Check version (local vs published, sequential bump)
2. Run quality checks (fmt, lint, test, doc)
3. Verify git state (clean, main, pushed, CI green)
4. Generate release notes
5. Confirm before tagging/publishing

## Blocking Issues

STOP if:

- Version already published
- Lint/test failures
- Uncommitted changes
- CI failing
- Not on main

See `/release` for full workflow.
