---
name: github-actions-workflows
description: Use when writing, auditing, or fixing GitHub Actions workflows — CI, release, or deployment. Trigger on: creating a new workflow, reviewing an existing one, debugging a failure, or when a workflow caused an incident (partial publish, orphaned tag, flaky CI, etc.)
---

# GitHub Actions Workflow Engineering

Patterns for CI and release workflows that are correct, safe, and recoverable.

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
- [ ] Dependency cache enabled (use setup action's `cache: true` if available, else `actions/cache`)
- [ ] Build artifact verified (e.g. binary runs, `--version` output matches)
- [ ] Release workflow is a superset of this — never fewer checks before publish than before merge

### Release workflows

- [ ] Pre-flight validations before any side effects (format, tag exists, registry version exists)
- [ ] Full CI suite mirrored from `ci.yml` — release should be a superset, never a subset
- [ ] Binary/artifact version verified after build
- [ ] Tag pushed **after** publish, not before
- [ ] Concurrency group with `cancel-in-progress: false`
- [ ] `dry_run` input for testing without publishing

### General

- [ ] Action versions pinned (`@v4`, not `@latest`)
- [ ] Tool versions pinned where breakage is costly (`bun-version: "1.x"` over `latest`)
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

      # setup-bun@v2 has built-in caching — use cache: true instead of actions/cache
      - uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest # pin for release stability
          cache: true

      - name: Install dependencies
        run: bun install --frozen-lockfile

      # Cheap checks first — fail fast before running tests
      - name: Type check # adapt for your stack
        run: bunx tsc --noEmit

      - name: Lint
        run: bun run lint

      - name: Format check
        run: bunx oxfmt --check src

      - name: Test
        run: bun test

      - name: Build
        run: bun run build

      - name: Verify binary # confirm artifact works, not just compiles
        run: ./binary --version
```

**What belongs in CI:** everything required before merging. Fail early — type/lint before test. No side effects, no write-access secrets.

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
      VERSION: ${{ inputs.version }} # use env var, not direct interpolation
    steps:
      # 1. Validate (fail fast, no side effects)
      # 2. Full CI suite
      # 3. Bump version + build + verify
      # 4. Push main
      # 5. Publish to registry
      # 6. Push tag  ← after publish, not before
      # 7. Create release
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
| Tag push       | npm published, no tag           | `git tag vX.Y.Z && git push origin vX.Y.Z` |
| GitHub release | tag exists, npm published       | Re-run or `gh release create` manually     |

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

- name: Check version not already on npm
  run: |
    if npm view "@scope/pkg@$VERSION" version 2>/dev/null; then
      echo "Error: @scope/pkg@$VERSION already published"
      exit 1
    fi
```

---

## Security: Env Vars for User Inputs

```yaml
# UNSAFE — direct interpolation is shell injection
run: git tag "v${{ inputs.version }}"

# SAFE — set at job level, use as normal env var in all steps
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

| Ecosystem | Cache path                     | Key                              |
| --------- | ------------------------------ | -------------------------------- |
| Bun       | `~/.bun/install/cache`         | `hashFiles('bun.lockb')`         |
| npm/Node  | `~/.npm`                       | `hashFiles('package-lock.json')` |
| Cargo     | `~/.cargo/registry`, `target/` | `hashFiles('Cargo.lock')`        |
| Go        | `~/go/pkg/mod`                 | `hashFiles('go.sum')`            |
| uv/Python | `~/.cache/uv`                  | `hashFiles('uv.lock')`           |

Always set `restore-keys` as a fallback for partial cache hits.

---

## Common Mistakes

| Mistake                                  | Consequence                                 | Fix                               |
| ---------------------------------------- | ------------------------------------------- | --------------------------------- |
| Tag before publish                       | Orphaned tag if publish fails               | Push tag after publish            |
| Release skips lint/tsc/format            | Ships broken or malformed code              | Mirror full CI suite              |
| `${{ inputs.x }}` in `run:`              | Shell injection                             | Use job-level `env:`              |
| No pre-flight checks                     | Re-run after partial failure corrupts state | Validate before any side effects  |
| No concurrency group on release          | Simultaneous runs race past validations     | `concurrency: group: release`     |
| `cancel-in-progress: true` on release    | Active release killed mid-publish           | Use `false` for release           |
| No cache on CI                           | Full install every run, slow feedback       | Add `actions/cache`               |
| Tool version unpinned on release         | Breaking update silently breaks release     | Pin or document the accepted risk |
| `--allow-same-version` without pre-check | Silently re-releases without noticing       | Check registry before running     |
| CI only runs on `push` to main           | PRs merge broken code                       | Add `pull_request` trigger        |
