# AI Agent Instructions

## System Context
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Critical Rules
- NO AI attribution in commits/PRs (strip if found)
- Ask before: pushing to remote, opening PRs
- Never force push to main/master
- NO archiving (delete files, git preserves history)
- NO temp files (delete immediately after use)
- Commit frequently after each logical change, push regularly

## Where Information Belongs
- Universal rules (all projects) → Global `~/.claude/CLAUDE.md`
- Project overview + pointers → Project `CLAUDE.md` (~100-200 lines)
  - Optional: `ln -s CLAUDE.md AGENTS.md`
- Detailed issues → `ai/STATUS.md` (read FIRST)
- Tasks → `ai/TODO.md`
- Decisions → `ai/DECISIONS.md`
- Research → `ai/RESEARCH.md` + `ai/research/`
- Permanent docs → `docs/`
- Update ai/STATUS.md every session, NO dated summaries
- Reference commits by hash (e.g., "Fixed in a1b2c3d")
- Reference: github.com/nijaru/agent-contexts

## ai/ Directory: Machine-Optimized
**ai/ is for AI agents, docs/ is for users/team**

ai/ writing:
- Tables, lists, key-value pairs (NOT narrative prose)
- Answer first, evidence second (inverted pyramid)
- Docs >500 lines: Executive summary at top
- Cross-reference, don't duplicate

## Code Standards
Before implementing:
- Research best practices - is this truly SOTA?
- Test as you go before moving to next step
- IF changes break existing code → ask unless explicitly required

Always:
- Production-ready: error handling, logging, validation
- Follow existing patterns in codebase
- Update project docs (README, docs/, internal/) and agent context (ai/, CLAUDE.md)
- Verify: codebase production-ready, all tests pass

## Testing & Validation
- Test in containers/isolated environments where possible
- Use Fedora for hardware-intensive/Linux-specific testing

## Naming Conventions
**Variables:**
- Boolean: `isEnabled`, `hasData`, `canRetry`
- Constants: `MAX_RETRIES`, `DEFAULT_PORT`
- With units: `timeoutMs`, `bufferKB`
- Collections: plural (`users`, `items`)

**Functions:**
- Side effects: action verb (`updateDatabase`, `saveUser`)
- Query only: get/find/check (`getUser`, `findById`)
- Boolean return: is/has/can (`isValid`, `hasPermission`)

## Comments
Default: NO comments (self-documenting code > comments)

Add ONLY for WHY (never WHAT):
- Non-obvious decisions: `# Use 1000 threshold - benchmarks show 3x speedup`
- External requirements: `# GDPR requires 7-year retention`
- Algorithm rationale: `# Quickselect over sort - only need top K`
- Workarounds: `# Workaround: Library X lacks feature Y`

NEVER: Obvious behavior, TODOs, emotional comments, syntax explanations

## Git Workflow
Format: `type: description` (feat, fix, docs, refactor, test, chore)

Versions (MAJOR.MINOR.PATCH):
- DEFAULT: Never bump versions (track via commit hashes)
- Only bump when explicitly instructed
- NO drastic jumps (0.0.1 → 1.0.0 is bad)
- 1.0.0 = production-ready, stable API

## Release Process
**Only when explicitly instructed. CRITICAL: Never tag/release before CI passes!**

1. Bump version + update docs
2. `git add -u && git commit -m "chore: bump version to X.Y.Z" && git push`
3. **WAIT FOR CI**: `gh run watch` (all checks ✅)
4. `git tag -a vX.Y.Z -m "vX.Y.Z - Description" && git push --tags`
5. `gh release create vX.Y.Z --notes-file release_notes.md`
6. Publish: `cargo publish` (Rust), `npm publish` (Node), `uv publish` (Python)

If CI fails: Delete tag/release, fix, restart

## ASK on Blockers
STOP and ask when hitting:
- Package name conflicts
- Permission/access denied
- API rejections or unexpected failures
- Service unavailable or quota exceeded
- Ambiguous requirements or conflicting constraints
- Unclear which approach to take

## Toolchains

**Python**: uv + mise (never pip)
- Tools: ruff (lint), ty (type check), vulture (find unused code)
- Commands: `uv init && uv sync`, `uv add [pkg]`, `uv run python script.py`
- `uv run ruff check . --fix`, `uvx ty check .`, `uvx vulture . --min-confidence 80`

**JavaScript/TypeScript**: bun + mise (never npm/yarn)
- Commands: `bun init`, `bun add [pkg]`, `bun run script.ts`, `bun test`, `bun build`

**Other**: mise for version management, consult official docs

**Web/CLI/TUI**: Use icon libraries (lucide, heroicons), NOT emoji characters in UI

## Performance Claims
CRITICAL: Never compare different levels of the stack

Before claiming "Nx faster":
- Same features (ACID, durability, persistence)
- Same workload (not bulk vs incremental)
- Realistic data distribution (not best-case only)
- Multiple runs (3+), report median, document caveats

Format:
- ❌ "System X is 100x faster than Y"
- ✅ "System X: 20x faster bulk inserts for sequential timestamps vs Y (both with durability). 10M rows. Random: 2-5x."

Stop if speedup >50x - verify: same abstraction level? all features? realistic data? can you explain WHY?
