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

## Where Information Belongs

**Quick Lookup**:
- Universal rules (all projects) → Global `~/.claude/CLAUDE.md`
- Project overview + pointers → Project `CLAUDE.md`/`AGENTS.md` (brief, ~100-200 lines)
- Detailed technical issues → `ai/STATUS.md` (read FIRST)
- Active tasks → `ai/TODO.md`
- Decisions + rationale → `ai/DECISIONS.md`
- Research → `ai/RESEARCH.md` + `ai/research/`
- Permanent docs → `docs/`

**Project CLAUDE.md/AGENTS.md**:
- ✅ Brief: `"⚠️ Model routing issues. See ai/STATUS.md"`
- ❌ Detailed: `"⚠️ Model Routing: 1. Issue A... 2. Issue B..."`

**Key Rules**:
- Update ai/STATUS.md every session, NO dated summaries
- Reference commits by hash (e.g., "Fixed in a1b2c3d")
- Reference: github.com/nijaru/agent-contexts

## Code Standards
Before implementing:
- Research best practices first - ask: Is this truly state-of-the-art?
- Test as you go before moving to next step
- IF changes break existing code → ask unless explicitly required

Always include:
- Production-ready: error handling, logging, validation
- Follow existing patterns in codebase
- Update project docs (README, docs/, internal/, API docs) and agent context (ai/, CLAUDE.md, AGENTS.md)
- Verify before done: codebase is production-ready, all tests pass

## Testing & Validation
- Test in containers/isolated environments where possible
- Use Fedora for hardware-intensive/Linux-specific testing

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
- **DEFAULT: Never bump versions** - track progress via commit hashes
- Only bump versions when explicitly instructed (e.g., "bump to 1.2.3", "bump patch", "create release")
- When bumping: NO drastic jumps (0.0.1 → 1.0.0 is bad, use 0.1.0 → 0.2.0 → 1.0.0)
- 1.0.0 = production-ready, stable API

## Release Process
**Only run when explicitly instructed to create a release**
**CRITICAL: Never tag/release before CI passes!**

1. Bump version (Cargo.toml, package.json, etc.) + update docs (README, STATUS.md, notes)
2. `git add -u && git commit -m "chore: bump version to X.Y.Z" && git push`
3. **WAIT FOR CI**: `gh run watch` - all checks must be ✅ before proceeding
4. `git tag -a vX.Y.Z -m "vX.Y.Z - Description" && git push --tags`
5. `gh release create vX.Y.Z --notes-file release_notes.md`
6. **Publish to registries**: `cargo publish` (Rust), `npm publish` (Node), `uv publish` (Python)

If CI fails: Delete tag/release (`git tag -d vX.Y.Z && git push --delete origin vX.Y.Z`), fix, restart.

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

### JavaScript/TypeScript
Toolchain: bun + mise (never npm/yarn)
```bash
mise install bun@latest && mise use bun@latest
bun init                    # initialize project
bun add [packages]          # dependencies
bun add -d [packages]       # dev dependencies
bun run script.ts           # run code (no build step needed)
bun test                    # test runner
bun build                   # bundle for production
bunx [tool]                 # run packages without installing
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
