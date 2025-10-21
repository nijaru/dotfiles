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

Always include:
- Production-ready: error handling, logging, validation
- Follow existing patterns in codebase
- Update project docs (README, internal/, API docs) not inline comments
- Verify before done: codebase is production-ready, all tests pass

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

## ASK on Blockers
STOP and ask for clarification when hitting:
- Package name conflicts (PyPI, npm, etc.)
- Permission/access denied errors
- API rejections or unexpected failures
- Service unavailable or quota exceeded
- Ambiguous requirements or conflicting constraints
- Unclear which approach to take between valid options

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
Rust/Go/Mojo: Load toolchain from agent-contexts patterns as needed

### Web Development
- Use icon libraries (lucide, heroicons) not emoji characters in UI

## Pattern Library
Location: `external/agent-contexts/` or `~/github/nijaru/agent-contexts/`

Load on-demand for specific tasks:
- `languages/{rust,python,go,mojo}/PATTERNS.md` - Language-specific patterns
- `standards/{ERROR,DOC,AI_CODE,RELEASE}_PATTERNS.md` - Universal standards
- `tools/{jj,github,uv,modular}/PATTERNS.md` - Tool workflows

Usage:
```
IF writing Rust code → Load languages/rust/RUST_PATTERNS.md
IF organizing docs → Load standards/DOC_PATTERNS.md
IF debugging errors → Load standards/ERROR_PATTERNS.md
IF using specific tool → Load tools/[tool]/[TOOL]_PATTERNS.md
```

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
