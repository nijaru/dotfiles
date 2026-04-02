---
name: github-actions-workflows
description: Use when writing, auditing, or fixing GitHub Actions workflows for CI, release, or deployment. Trigger on new workflow creation, auditing existing ones, or debugging pipeline failures and incidents.
allowed-tools: Bash, Read, Grep, Glob, Edit
---

# GitHub Actions Workflow Engineering

## Core Mandates

- **Security:** Never use `${{ inputs.* }}` or `${{ github.event.* }}` directly in `run:` blocks. Always map to `env:` variables.
- **Ordering:** Follow the "Validation -> CI -> Build -> Verify -> Publish -> Tag" sequence. Tagging MUST be the final step.
- **Stability:** Pin all action versions (`@v4`) and runtime versions. Never use `@latest`.
- **Efficiency:** Enable native caching in setup actions (e.g., `cache: true` in `setup-go`).

## Implementation Standards

### 1. Release Orchestration
Order matters for recoverability. Tag only after a successful publish.
1. **Validate:** Check version format and registry availability.
2. **CI Suite:** Run full tests/lints (superset of standard CI).
3. **Build & Verify:** Build artifact and run `--version` check.
4. **Publish:** Push to registry (npm, Cargo, PyPI).
5. **Tag & Release:** `git tag` and `gh release create` only after success.

### 2. Concurrency Control
```yaml
# CI: Cancel redundant runs on same branch
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

# Release: NEVER cancel in-flight publishes
concurrency:
  group: release
  cancel-in-progress: false
```

### 3. Pre-flight Validations
Always verify state before side effects:
- Version format (Regex check).
- Tag non-existence (`git ls-remote --tags`).
- Registry availability (e.g., `npm view`).

## Security Injection Prevention

**UNSAFE:**
```yaml
run: git tag "v${{ inputs.version }}"
```

**SAFE:**
```yaml
jobs:
  release:
    env:
      VERSION: ${{ inputs.version }}
    steps:
      - run: git tag "v$VERSION"
```

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "It's just a simple CI script." | Minimal scripts lack the concurrency and caching controls required for reliable production pipelines. |
| "Tagging first is easier to track." | Tagging before publishing creates orphaned remote tags that block clean re-runs after failures. |
| "I don't need to pin versions." | Unpinned runtimes or actions cause silent, non-deterministic breakage when upstreams update. |

## Troubleshooting

- **Partial Failure:** If publish fails, fix the cause and re-run. Pre-flight checks will pass as the registry remains clean.
- **Orphaned Tag:** If a tag was pushed but publish failed, delete the remote tag before re-running.
- **Injection Risks:** Audit all `run:` blocks for `${{ }}` interpolation; replace with `env:` mapping immediately.
