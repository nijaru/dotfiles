---
description: Pre-release verification and publish workflow
argument-hint: "[version]"
allowed-tools: Read, Grep, Glob, Bash
---

Release workflow: verify code quality, check versions, tag, and publish.

$ARGUMENTS

---

## 1. Detect Project Type

```bash
# Run in parallel
ls Cargo.toml package.json pyproject.toml go.mod 2>/dev/null
```

## 2. Version Check

### Current Version

| Project | Command                                     |
| ------- | ------------------------------------------- |
| Rust    | `grep '^version' Cargo.toml \| head -1`     |
| Node    | `jq -r .version package.json`               |
| Python  | `grep '^version' pyproject.toml \| head -1` |
| Go      | `grep 'module' go.mod` + git tags           |

### Published Version

| Registry  | Command                                            |
| --------- | -------------------------------------------------- |
| crates.io | `cargo search <name> 2>/dev/null \| head -1`       |
| npm       | `npm view <name> version 2>/dev/null`              |
| PyPI      | `pip index versions <name> 2>/dev/null \| head -1` |

### Validation

- [ ] Version bumped (current > published)
- [ ] Sequential bump only (0.0.8 → 0.0.9, NOT 0.0.8 → 1.0.0)
- [ ] Not already published (would fail anyway)

**STOP if version already exists on registry.**

## 3. Code Quality

Run ALL checks. Any failure = STOP.

**Rust:**

```bash
cargo fmt --check
cargo clippy --lib -- -D warnings -W clippy::pedantic
cargo test --lib
cargo doc --no-deps
```

**Python:**

```bash
uv run ruff check .
uv run ruff format --check .
uv run pytest
```

**TypeScript:**

```bash
bun x biome check .
bun test
```

**Go:**

```bash
gofmt -l . | grep . && exit 1
go vet ./...
staticcheck ./...
go test ./...
```

## 4. Git State

```bash
# All must pass
git status --porcelain              # Empty = clean
git branch --show-current           # main or master
git log origin/main..HEAD --oneline # Empty = pushed
```

- [ ] Working directory clean
- [ ] On main/master branch
- [ ] All commits pushed

## 5. CI Status

```bash
gh run list --branch main --limit 5 --json status,conclusion,name,headSha \
  --jq '.[] | "\(.name): \(.conclusion // .status)"'
```

- [ ] All workflows passing (success)
- [ ] Latest commit matches HEAD

**STOP if CI failing.**

## 6. Release Notes

```bash
# Get commits since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -n "$LAST_TAG" ]; then
  git log ${LAST_TAG}..HEAD --oneline
else
  git log -20 --oneline
fi
```

Summarize changes:

- Features added
- Bugs fixed
- Breaking changes (require major version bump if post-1.0)
- Dependencies updated

## 7. Pre-Release Summary

Present to user:

```
Release Check: [PROJECT NAME]
=============================

Version:  X.Y.Z (was X.Y.W on registry)
Branch:   main (clean, pushed)
CI:       all passing
Quality:  fmt ✓ lint ✓ test ✓ docs ✓

Changes since vX.Y.W:
- [summary of commits]

Ready to release? (yes/no)
```

**STOP and wait for explicit "yes" confirmation.**

## 8. Tag

After confirmation:

```bash
git tag -a vX.Y.Z -m "vX.Y.Z: [brief summary]"
git push origin vX.Y.Z
```

## 9. Publish

Check for release workflow:

```bash
ls .github/workflows/release.yml 2>/dev/null
```

If exists and manual trigger:

```bash
gh workflow run release.yml --ref vX.Y.Z
```

If auto-triggered by tag, wait and monitor:

```bash
gh run list --limit 1
```

## 10. Verify

After workflow completes:

```bash
# Check registry
cargo search <name>  # or npm view / pip index
```

Confirm published version matches.

---

## Blocking Issues (STOP)

- Version already published
- Lint/test failures
- Uncommitted changes
- CI failing
- Not on main branch

## Non-Blocking Warnings

- Missing CHANGELOG update
- No release notes in tag message
