---
name: github-actions-workflows
description: Use when writing, auditing, or fixing GitHub Actions workflows — CI, release, or deployment. Trigger on: creating a new workflow, reviewing an existing one, debugging a failure, or when a workflow caused an incident (partial publish, orphaned tag, flaky CI, etc.)
---

# GitHub Actions Workflow Engineering

Non-obvious patterns that get missed in practice. Covers CI and release workflows across any language stack.

## Audit Checklist

### Security

- [ ] No `${{ inputs.* }}` or `${{ github.event.* }}` directly in `run:` — use `env:` vars (see below)
- [ ] Minimal permissions — `contents: read` default, escalate only where needed
- [ ] `pull_request_target`? High risk — has write access and runs fork code

### CI

- [ ] Triggers on both `push: main` and `pull_request: main`
- [ ] Concurrency cancels in-progress runs on same ref (`cancel-in-progress: true`)
- [ ] Step order: static checks (type/lint/format) → test → build → verify artifact
- [ ] Dependency cache enabled (setup actions often have `cache: true` built in)
- [ ] Artifact verified at end — runs with `--version`, not just "build succeeded"

### Release

- [ ] Pre-flight validations before any side effects (version format, tag exists, registry version exists)
- [ ] Full CI suite — release must be a superset of CI, never fewer checks
- [ ] Artifact version verified after build (matches input version)
- [ ] Tag pushed **after** publish
- [ ] Concurrency group with `cancel-in-progress: false`
- [ ] `dry_run` input wired up

### General

- [ ] Action versions pinned (`@v4` not `@latest`)
- [ ] Runtime versions pinned on release (breakage there is silent and hard to debug)

---

## Release Step Ordering

The one thing most people get wrong. Order matters for recoverability:

```
validate → CI suite → bump version → build → verify → push main → publish → push tag → create release
```

**Tag goes last.** Tag = "this shipped." Don't push it until it has. If publish fails before the tag is pushed, no orphaned remote tag, and re-running is clean.

**Push main before publish.** Version commit should exist on main before the package is live.

**Recovery after partial failure:**

| What failed    | State                           | Recovery                                                    |
| -------------- | ------------------------------- | ----------------------------------------------------------- |
| Publish        | main pushed, no tag, no release | Fix cause, re-run — pre-checks pass since registry is clean |
| Tag push       | published, no tag               | `git tag vX.Y.Z && git push origin vX.Y.Z`                  |
| GitHub release | tag + package exist             | Re-run or `gh release create` — idempotent                  |

---

## Pre-flight Validation Pattern

Run before any side effects. Cheap checks first. All use `env: VERSION` (not direct interpolation).

```yaml
- name: Validate version format
  run: |
    if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
      echo "Error: version must be X.Y.Z (got: $VERSION)"; exit 1
    fi

- name: Check tag does not already exist
  run: |
    if git ls-remote --tags origin "refs/tags/v$VERSION" | grep -q .; then
      echo "Error: tag v$VERSION already exists"; exit 1
    fi

- name: Check version not already published
  run: |
    # npm: npm view "pkg@$VERSION" version 2>/dev/null
    # cargo: cargo search pkg | grep "^pkg " | grep -q "$VERSION"
    # PyPI: pip index versions pkg 2>/dev/null | grep -q "$VERSION"
    if npm view "pkg@$VERSION" version 2>/dev/null; then
      echo "Error: pkg@$VERSION already published"; exit 1
    fi
```

---

## Security: Env Vars for Inputs

`${{ inputs.x }}` in `run:` is interpolated before shell execution — injection risk.

```yaml
# UNSAFE
run: git tag "v${{ inputs.version }}"

# SAFE — set at job level
jobs:
  release:
    env:
      VERSION: ${{ inputs.version }}
    steps:
      - run: git tag "v$VERSION"
```

Safe contexts (no shell execution): `with:` blocks, `if:` expressions, `env:` assignment values.

---

## Concurrency

```yaml
# CI — cancel redundant runs on same branch/PR
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

# Release — never cancel in-flight
concurrency:
  group: release
  cancel-in-progress: false
```

Easy mistake: copying CI's `cancel-in-progress: true` into release and killing a publish mid-flight.

---

## Setup Actions with Built-in Cache

Prefer setup action's native cache over a separate `actions/cache` step — simpler and avoids conflicts.

| Ecosystem  | Action                   | Cache flag                          |
| ---------- | ------------------------ | ----------------------------------- |
| Bun        | `oven-sh/setup-bun@v2`   | `cache: true`                       |
| Go         | `setup-go@v5`            | `cache: true`                       |
| Node/npm   | `setup-node@v4`          | `cache: "npm"`                      |
| Python/pip | `setup-python@v5`        | `cache: "pip"`                      |
| Rust/Cargo | `dtolnay/rust-toolchain` | none — use `actions/cache` manually |

---

## Common Mistakes

| Mistake                               | Consequence                                   | Fix                          |
| ------------------------------------- | --------------------------------------------- | ---------------------------- |
| Tag before publish                    | Orphaned remote tag if publish fails          | Push tag after publish       |
| Release skips checks CI runs          | Ships code that wouldn't merge                | Mirror full CI suite         |
| `${{ inputs.x }}` in `run:`           | Shell injection                               | Job-level `env:`             |
| No pre-flight checks                  | Partial re-run corrupts state                 | Validate before side effects |
| `cancel-in-progress: true` on release | Kills active publish                          | Use `false`                  |
| No registry pre-check                 | Re-run after partial failure double-publishes | Check before any push        |
| CI only on `push` to main             | PRs merge broken code                         | Add `pull_request` trigger   |
| Runtime version unpinned on release   | Silent breakage when upstream releases        | Pin version                  |
