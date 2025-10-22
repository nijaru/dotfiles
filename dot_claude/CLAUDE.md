# AI Agent Instructions

## System Context
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Critical Rules (Always Follow)
- NO AI attribution in commits/PRs. Strip if found.
- Ask before: pushing to remote, opening PRs
- Never force push to main/master
- NO archiving - delete files directly (git preserves history)
- NO temp files - delete immediately after use
- Commit frequently after each logical change
- Push regularly to keep remote in sync

## Code Standards
Before implementing:
- Research best practices first - ask: Is this truly state-of-the-art?
- Test as you go before moving to next step
- IF changes break existing code → ask unless explicitly required

Agent knowledge organization:
- Use standard `ai/` structure: TODO.md, STATUS.md, DECISIONS.md, RESEARCH.md
- Guide: `github.com/nijaru/agent-contexts` (organization, not coding patterns)

Always include:
- Production-ready: error handling, logging, validation
- Follow existing patterns in codebase
- Update project docs (README, docs/, internal/, API docs) and agent context (ai/, CLAUDE.md, AGENTS.md)
- Verify before done: codebase is production-ready, all tests pass

## Naming Conventions
Variables:
- Boolean → question form: `isEnabled`, `hasData`, `canRetry`
- Constants → UPPER_SNAKE: `MAX_RETRIES`, `DEFAULT_PORT`
- With units → include unit: `timeoutMs`, `bufferKB`
- Collections → plural: `users`, `items`

Functions:
- Side effects → action verb: `updateDatabase`, `saveUser`
- Query only → get/find/check: `getUser`, `findById`
- Boolean return → is/has/can: `isValid`, `hasPermission`

## Comments (Rarely Needed)
Default: NO comments. Self-documenting code > comments.

Add ONLY for WHY (never WHAT):
- Non-obvious decisions: `# Use 1000 threshold - benchmarks show 3x speedup`
- External requirements: `# GDPR requires 7-year retention`
- Algorithm rationale: `# Quickselect over sort - only need top K`
- Complexity notes: `# O(n log n) despite linear scan - sorting dominates`
- External workarounds: `# Workaround: Library X lacks feature Y`

NEVER:
- Obvious code behavior: `# Increment counter`
- TODOs (fix before commit)
- Emotional/narrative comments: `# CRITICAL FIX!`
- Syntax explanations (use better variable names)

## Git Workflow
Format: `type: description` (feat, fix, docs, refactor, test, chore)
Frequency: Commit after each logical change, push regularly

Versions: MAJOR.MINOR.PATCH (breaking.feature.bugfix)
- NO drastic jumps: 0.0.1 → 1.0.0 is bad, use 0.1.0 → 0.2.0 → 1.0.0
- 1.0.0 = production-ready, stable API

## Release Checklist (CRITICAL)
**NEVER tag or release before CI passes!**

Pre-release steps (in order):
1. **Code complete**: All features implemented and tested locally
2. **Version bump**: Update version in all relevant files (Cargo.toml, package.json, etc.)
3. **Update docs**: README, CHANGELOG, STATUS.md, release notes
4. **Commit changes**: `git add -u && git commit -m "chore: bump version to X.Y.Z"`
5. **Push to remote**: `git push`
6. **WAIT FOR CI**: Use `gh run watch` or check GitHub Actions
   - ✅ All checks must be GREEN (lint, test, build, integration)
   - ❌ If CI fails: fix issues, DO NOT proceed
7. **Tag release**: Only after CI passes: `git tag -a vX.Y.Z -m "vX.Y.Z - Description"`
8. **Push tag**: `git push --tags`
9. **Create GitHub release**: `gh release create vX.Y.Z --notes-file release_notes.md`
10. **Verify release workflow**: Check that release binaries build successfully

**Common mistakes to avoid:**
- ❌ Tagging before CI completes
- ❌ Releasing with failing tests
- ❌ Skipping version updates in documentation
- ❌ Forgetting to update CHANGELOG/STATUS
- ❌ Using `git commit && git tag && git push --all --tags` in one line

**If you released prematurely:**
1. Check CI status immediately: `gh run list --limit 5`
2. If CI failed: delete tag and release, fix issues, restart process
3. If CI passed: You got lucky, but don't do it again!

## ASK on Blockers
STOP and ask for clarification when hitting:
- Package name conflicts (PyPI, npm, etc.)
- Permission/access denied errors
- API rejections or unexpected failures
- Service unavailable or quota exceeded
- Ambiguous requirements or conflicting constraints
- Unclear which approach to take between valid options

## Common Error Patterns
| Error | Fix |
|-------|-----|
| `No current bookmark` (jj) | `jj bookmark create main` |
| `Working copy is stale` (jj) | `jj edit @` |
| `not a git repository` | `cd` to repo or `git init` |
| `port already in use` | `lsof -ti:PORT \| xargs kill` |
| `permission denied` | `chmod +x file` or check ownership |
| `module not found` | Check dependencies, run install |

## Language-Specific

### Python
Toolchain: uv + mise (never pip)
```bash
mise install python@latest && mise use python@latest
uv init && uv sync
uv add [packages]           # dependencies
uv add --dev [packages]     # dev dependencies
uv run python script.py     # run code
uv run ruff check . --fix   # lint (800+ rules, auto-fix)
uv format                   # format code
uvx vulture . --min-confidence 80  # find unused code
uvx ty check .              # type checking (replaces mypy/pyright)
```

### Other Languages
Rust/Go/Mojo: Use mise for version management, consult official docs for patterns

### Web Development
- Use icon libraries (lucide, heroicons) not emoji characters in UI

## Performance Claims
CRITICAL: Never compare different levels of the stack.

Before claiming "Nx faster":
- Same features (ACID, durability, persistence)
- Same workload (not bulk vs incremental)
- Same data distribution (realistic, not best-case only)
- Multiple runs (3+), report median, document caveats

Bad: "System X is 100x faster than Y"
Good: "System X: 20x faster bulk inserts for sequential timestamps vs Y (both with durability). 10M rows. Random: 2-5x."

Stop if speedup >50x - verify: same abstraction level? all features? realistic data? can you explain WHY?
