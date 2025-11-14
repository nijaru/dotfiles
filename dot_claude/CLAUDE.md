# AI Agent Instructions

## Environment
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Workflow Rules
- NO AI attribution in commits/PRs (strip manually)
- Ask before: PRs, publishing packages, force ops, resource deletion
- Commit frequently, push regularly (no ask needed)
- Never force push to main/master
- Delete files directly (no archiving)
- `/tmp`: ephemeral test artifacts only. `ai/`: context/state across sessions
  - Delete temp artifacts after use, never commit

### ai/ Directory
**AI session context** - workspace for tracking project state across sessions. Read first, update on exit.

| File | Purpose |
|------|---------|
| `AGENTS.md` | Project overview (symlink: `CLAUDE.md` → `AGENTS.md`) |
| `ai/STATUS.md` | Current state, blockers (read FIRST) |
| `ai/TODO.md` | Active tasks only |
| `ai/PLAN.md` | Architecture, dependencies (if 3+ phases) |
| `ai/DECISIONS.md` | Active decisions, trade-offs |
| `ai/RESEARCH.md` + `ai/research/` | Research index + detailed findings |
| `ai/design/` | Design specifications |
| `ai/decisions/` | Superseded/split decisions |
| `docs/` | User documentation |

**Format:** All ai/ files - tables/lists/structured (not prose). Answer first, evidence second. Exec summary if lengthy.

**Maintenance:** Keep current/active only. Delete historical/completed content. Archive superseded decisions to `ai/decisions/superseded-YYYY-MM.md`.

**Principle:** Session files (ai/ root) read every session - keep focused on current work. Reference files (subdirs) loaded on demand - detailed content with zero token cost unless accessed.

Anti-pattern: Time tracking files (WEEK*_DAY*.md), narrative prose, size-based decisions

Reference: github.com/nijaru/agent-contexts

## Development

**Do it right the first time.** Rushing leads to bugs, tech debt, and rework. Research, understand requirements, plan, implement.

### Code Quality
- Research best practices first (state of the art)
- Fix root cause, no workarounds
- Production-ready: error handling, logging, validation
- Follow existing patterns
- Update docs: README, docs/, ai/, AGENTS.md
- Ask before breaking existing code

### Testing & TDD
TDD provides binary success criteria, prevents drift. AI excels at test generation and rapid iteration.

**Workflow:** Plan → Red → Green → Refactor → Validate

| Use TDD | Skip |
|---------|------|
| Systems: DBs, compilers, storage | Docs, configs, typos |
| Performance: SIMD, algorithms, hot paths | Prototypes, spikes |
| Services with test infrastructure | Simple scripts, fixes |
| Complex logic prone to regression | Exploratory code |

**Rules:**
- Declare TDD upfront (prevents mock implementations)
- Commit tests before coding, don't modify during implementation
- Iterate until green

### Code Style

**Naming:** Concise, context-aware, no redundancy
- Proportional to scope (local: `count`, package: `userCount`)
- Omit redundant context (`Cache` not `LRUCache_V2`, `users` not `userSlice`)
- Omit type info already clear (`count` not `numUsers`, `timeout` not `timeoutInt`)
- Booleans: `isEnabled`/`hasData`. Constants: `MAX_RETRIES`. Units: `timeoutMs`/`bufferKB`

**Comments:** Only WHY, never WHAT. NO narrating code changes.
- Write: non-obvious decisions, external requirements, algorithm rationale, workarounds
- Never: change tracking, obvious behavior, TODOs, what code does

**Rust:**
- Avoid allocations: `&str` not `String`, `&[T]` not `Vec<T>`, no `.clone()` shortcuts
- Errors: `anyhow` (apps), `thiserror` (libs)
- Async: sync for files, `tokio` for network, `rayon` for CPU
- Edition: "2024"

## Git & Releases

**Versioning:**
- Use commit hashes for references
- Bump versions only when instructed
- 0.1.0+ = production ready. 1.0.0 = proven in production
- Sequential bumps only: 0.0.1 → 0.0.2 → 0.1.0 → 1.0.0 (not 0.0.1 → 1.0.0)

**Release:** (wait for CI ✅)
1. Bump version, update docs → commit → push
2. `gh run watch` (wait for pass)
3. Tag: `git tag -a vX.Y.Z -m "Description" && git push --tags`
4. `gh release create vX.Y.Z --notes-file release_notes.md`
5. ASK before publishing (can't unpublish)

CI fails: delete tag/release, fix, restart

## Stack

**Languages:** Python, Rust, Go, Bun preferred. Shell: `nushell` for typed data/JSON/CSV. Mojo: experimental (evaluate first).

**Packages:** Let package manager choose versions unless pinning required.
- `cargo add serde` (not `cargo add serde@1.0`)
- `uv add requests` (not `uv add requests==2.31.0`)
- `bun add zod` (not `bun add zod@3.22.0`)
- Pin only for: reproducibility requirements, known breaking changes, or explicit user request

**Toolchains:**
- Python: `uv` (not pip/venv) → `uv init && uv sync`, `uv add [pkg]`, `uv run python script.py`
  - Lint: `uv run ruff check . --fix`, `uvx ty check .`, `uvx vulture . --min-confidence 80`
- JS/TS: `bun` → `bun init`, `bun add [pkg]`, `bun run script.ts`, `bun test`, `bun build`
- Versions: `mise`
- UI: Icon libraries (lucide, heroicons), never emoji

**CLI Tools:** Prefer structured output, modern alternatives

| Instead of | Use | Why |
|------------|-----|-----|
| grep | `rg` (ripgrep) | Faster, respects .gitignore |
| find | `fd` | Simpler syntax |
| sed | `sd` | Safer defaults |
| awk | `miller` | Proper CSV/TSV/JSON |
| curl | `xh`/`httpie` | Structured output |
| rsync | `sy` | 2-11x faster, parallel (experimental) |

For jq/yq/ast-grep: use for proper JSON/YAML/AST manipulation.

## Standards

**Performance Claims:**
Never compare different abstraction levels. Requirements:
- Same features (ACID, durability, etc.)
- Same workload, realistic data
- 3+ runs, report median + caveats
- If >50x speedup: verify abstraction, explain WHY

Format: ✅ "X: 20x faster bulk inserts for sequential timestamps vs Y (both with durability). 10M rows. Random: 2-5x."
