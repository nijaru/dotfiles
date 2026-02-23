---
name: github-actions-workflows
description: Use when writing, auditing, or fixing GitHub Actions workflows — CI, release, or deployment. Trigger on: creating a new workflow, reviewing an existing one, debugging a failure, or when a workflow caused an incident (partial publish, orphaned tag, flaky CI, etc.)
---

# GitHub Actions Workflow Engineering

Patterns for CI and release workflows that are correct, safe, and recoverable. Language-agnostic — adapt commands for your stack.

## Audit Checklist

Run through this before writing or approving any workflow.

### Security

- [ ] No `${{ inputs.* }}` or `${{ github.event.* }}` directly in `run:` blocks — use `env:` vars
- [ ] Minimal permissions (`contents: read` default, escalate only where needed)
- [ ] `pull_request_target` used? High risk — write access + runs fork code. Avoid unless necessary.

### CI workflows

- [ ] Runs on both `push` to main and `pull_request` targeting main
- [ ] Concurrency cancels in-progress runs on same ref (saves minutes)
- [ ] Full suite: type check → lint → format → test → build → verify
- [ ] Dependency cache enabled (use setup action's built-in cache if available, else `actions/cache`)
- [ ] Build artifact verified (e.g. binary runs, `--version` output matches)
- [ ] Release workflow is a superset of this — never fewer checks before publish than before merge

### Release workflows

- [ ] Pre-flight validations before any side effects (version format, tag exists, registry version exists)
- [ ] Full CI suite mirrored — release should be a superset, never a subset
- [ ] Artifact version verified after build
- [ ] Tag pushed **after** publish, not before
- [ ] Concurrency group with `cancel-in-progress: false`
- [ ] `dry_run` input for testing without publishing

### General

- [ ] Action versions pinned (`@v4`, not `@latest`)
- [ ] Tool versions pinned where breakage is costly (e.g. `node-version: "22"` not `latest`)
- [ ] Partial failure leaves system in a recoverable state (see ordering)

---

## CI Workflow Structure

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true # cancel redundant runs on same ref

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Use your language's setup action — many have built-in cache: true
      # e.g. setup-node@v4, setup-go@v5, dtolnay/rust-toolchain, setup-python@v5
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm" # built-in caching where supported

      - name: Install dependencies
        run: npm ci # use lockfile-frozen install: npm ci, cargo fetch, go mod download, uv sync

      # Cheap checks first — fail fast before running tests
      - name: Type check # tsc --noEmit, cargo check, mypy, pyright, etc.
        run: npx tsc --noEmit

      - name: Lint # eslint, clippy, ruff check, golangci-lint, etc.
        run: npm run lint

      - name: Format check # prettier --check, rustfmt --check, ruff format --check, gofmt, etc.
        run: npm run format:check

      - name: Test
        run: npm test

      - name: Build
        run: npm run build

      - name: Verify artifact # confirm it works, not just compiles
        run: ./dist/binary --version
```

**What belongs in CI:** everything required before merging. Fail early — static checks before tests. No side effects, no write-access secrets.

**What does NOT belong:** publish, deploy, tag, release. Any secret with registry write access.

---

## Release Workflow Structure

```yaml
name: Release

on:
  workflow_dispatch:
    inputs:
      version:
        description: "Version (e.g. 1.2.3)"
        required: true
        type: string
      dry_run:
        description: "Skip publish and push"
        required: false
        type: boolean
        default: false

concurrency:
  group: release
  cancel-in-progress: false # never cancel an in-flight release

permissions:
  contents: write
  id-token: write # for provenance/OIDC publish

jobs:
  release:
    runs-on: ubuntu-latest
    env:
      VERSION: ${{ inputs.version }} # use env var, not direct interpolation in run:
    steps:
      # 1. Validate (fail fast, no side effects)
      # 2. Full CI suite
      # 3. Bump version + build + verify artifact version
      # 4. Push main
      # 5. Publish to registry
      # 6. Push tag  ← after publish, not before
      # 7. Create GitHub release
```

---

## Release Step Ordering (Minimize Blast Radius)

```
validate → CI → bump → build → verify → push main → publish → push tag → create release
```

**Why tag last:** Tag signals "this shipped." Only push it when it has. If publish fails before tag is pushed, no orphaned remote tag.

**Why push main before publish:** Version commit should be on main before the package is live.

**Recovery after partial failure:**

| What failed    | State                           | Recovery                                   |
| -------------- | ------------------------------- | ------------------------------------------ |
| Publish        | main pushed, no tag, no release | Fix cause, re-run (pre-checks will pass)   |
| Tag push       | package published, no tag       | `git tag vX.Y.Z && git push origin vX.Y.Z` |
| GitHub release | tag exists, package published   | Re-run or `gh release create` manually     |

---

## Pre-flight Validation Pattern

All checks before any side effects. Cheap first.

```yaml
- name: Validate version format
  run: |
    if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
      echo "Error: version must be X.Y.Z (got: $VERSION)"
      exit 1
    fi

- name: Check tag does not already exist
  run: |
    if git ls-remote --tags origin "refs/tags/v$VERSION" | grep -q .; then
      echo "Error: tag v$VERSION already exists"
      exit 1
    fi

# Registry check — adapt for your package manager:
# npm:   npm view "pkg@$VERSION" version 2>/dev/null
# cargo: cargo search "pkg" | grep "^pkg " | grep -q "$VERSION"
# PyPI:  pip index versions pkg 2>/dev/null | grep -q "$VERSION"
- name: Check version not already published
  run: |
    if npm view "pkg@$VERSION" version 2>/dev/null; then
      echo "Error: pkg@$VERSION already published"
      exit 1
    fi
```

---

## Security: Env Vars for User Inputs

```yaml
# UNSAFE — direct interpolation is shell injection
run: git tag "v${{ inputs.version }}"

# SAFE — set at job level, reference as normal env var
jobs:
  release:
    env:
      VERSION: ${{ inputs.version }}
    steps:
      - run: git tag "v$VERSION"
```

High-risk (always use env): `inputs.*`, `github.event.*.title`, `github.event.*.body`, `github.head_ref`, any user-controlled string.

Low-risk (no shell execution): `with:` blocks, `if:` expressions, `env:` assignment values.

---

## Dependency Caching

Many setup actions have built-in caching — prefer that over manual `actions/cache`.

| Ecosystem  | Setup action             | Built-in cache             | Manual cache path              |
| ---------- | ------------------------ | -------------------------- | ------------------------------ |
| Node/npm   | `setup-node@v4`          | `cache: "npm"`             | `~/.npm`                       |
| Bun        | `oven-sh/setup-bun@v2`   | `cache: true`              | `~/.bun/install/cache`         |
| Rust/Cargo | `dtolnay/rust-toolchain` | none — use `actions/cache` | `~/.cargo/registry`, `target/` |
| Go         | `setup-go@v5`            | `cache: true`              | `~/go/pkg/mod`                 |
| Python/uv  | `setup-python@v5`        | `cache: "pip"`             | `~/.cache/uv`                  |

For manual `actions/cache`, always set `restore-keys` as a fallback for partial cache hits.

---

## Common Mistakes

| Mistake                               | Consequence                                   | Fix                                       |
| ------------------------------------- | --------------------------------------------- | ----------------------------------------- |
| Tag before publish                    | Orphaned tag if publish fails                 | Push tag after publish                    |
| Release runs fewer checks than CI     | Ships code that wouldn't pass review          | Mirror full CI suite                      |
| `${{ inputs.x }}` in `run:`           | Shell injection                               | Use job-level `env:`                      |
| No pre-flight checks                  | Re-run after partial failure corrupts state   | Validate before any side effects          |
| No concurrency group on release       | Simultaneous runs race past validations       | `concurrency: group: release`             |
| `cancel-in-progress: true` on release | Active release killed mid-publish             | Use `false` for release                   |
| No dependency cache on CI             | Full install every run, slow feedback         | Use setup action cache or `actions/cache` |
| Tool version unpinned on release      | Breaking update silently breaks release       | Pin version or document the risk          |
| No registry pre-check before publish  | Re-run after partial failure double-publishes | Check registry before side effects        |
| CI only runs on `push` to main        | PRs merge broken code                         | Add `pull_request` trigger                |
