---
name: pre-release
description: >
  Automatically runs pre-release checks when release intent is detected.
  Triggers on: "release", "publish", "tag v", "bump version", "ship it",
  or commands like gh release, cargo publish, npm publish, pypi upload.
allowed-tools: Read, Grep, Glob, Bash
---

# Pre-Release Skill

Comprehensive checks before any release, publish, or version tag.

## When to Activate

- User mentions: "release", "publish", "ship", "tag", "bump version"
- Before running: `gh release`, `cargo publish`, `npm publish`, `uv publish`
- When version numbers are being updated
- User asks "ready to release?" or similar

## Pre-Release Checklist

### 1. Working Tree Status

```bash
git status --porcelain
```

- All changes committed?
- No untracked files that should be included?

### 2. Branch Status

```bash
git log origin/main..HEAD --oneline
```

- On correct branch (main/master)?
- Pushed to remote?
- CI passing?

### 3. Run Full Lint

Run language-appropriate linters with strict settings:

- Python: `uv run ruff check . && uvx ty check .`
- Rust: `cargo clippy -- -D warnings`
- Go: `go vet ./... && staticcheck ./...`
- TypeScript: `bun x biome check .` or `bun x eslint .`

### 4. Run Tests

```bash
# Detect and run test suite
```

- All tests passing?
- No skipped tests that should run?

### 5. Code Review

Invoke code-review skill for changes since last release:

```bash
git diff $(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~10)..HEAD
```

### 6. Version Validation

- Version bumped appropriately? (patch/minor/major)
- CHANGELOG updated?
- Version consistent across files (Cargo.toml, pyproject.toml, package.json)?

### 7. Documentation

- README up to date?
- API docs current?
- Breaking changes documented?

## Output Format

```
Pre-Release Check: [PROJECT NAME]
==================================

[✓] Working tree clean
[✓] On main branch, pushed
[✓] CI passing
[✓] Lint clean
[✓] Tests passing (N tests)
[✓] Code review: LGTM
[✓] Version: X.Y.Z (was X.Y.W)
[!] CHANGELOG: needs update

Ready to release: YES / NO (N issues)
```

## Blocking Issues

STOP and ask user to fix before proceeding:

- Uncommitted changes
- Lint errors
- Test failures
- ERROR-level code review issues

## Non-Blocking Warnings

Note but allow release:

- Missing CHANGELOG entry
- WARN-level code review issues
- Documentation slightly out of date
