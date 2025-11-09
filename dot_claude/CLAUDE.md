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
Session state. Read first, update on exit.

| File | Purpose |
|------|---------|
| `AGENTS.md` | Project overview (symlink: `CLAUDE.md` → `AGENTS.md`) |
| `ai/STATUS.md` | Current phase, blockers (read FIRST) |
| `ai/TODO.md` | Active tasks only |
| `ai/PLAN.md` | Architecture, dependencies (if 3+ phases) |
| `ai/DECISIONS.md` | Active decisions, trade-offs |
| `ai/RESEARCH.md` + `ai/research/` | Research inputs |
| `ai/design/` | Design outputs |
| `docs/` | User documentation |

**Format:** Tables/lists. Answer first, evidence second. Exec summary if >500 lines.

**Maintenance:** Keep current only. Delete completed items. Archive old decisions to `ai/decisions/superseded-YYYY-MM.md`.

Anti-pattern: Time tracking files (WEEK*_DAY*.md)

Reference: github.com/nijaru/agent-contexts

## Development

### Code Quality
- Research best practices first (state of the art)
- Fix root cause, no workarounds
- Production-ready: error handling, logging, validation
- Follow existing patterns
- Update docs: README, docs/, ai/, AGENTS.md
- Ask before breaking existing code

### Testing & TDD
TDD provides binary success criteria, prevents drift. AI excels at test generation and rapid iteration.

**Workflow:** Plan → Red (failing tests) → Green (minimal pass) → Refactor → Validate

| Use TDD | Skip |
|---------|------|
| Systems: DBs, compilers, storage | Docs, configs, typos |
| Performance: SIMD, algorithms, hot paths | Prototypes, spikes |
| Services with test infrastructure | Simple scripts, fixes |
| Complex logic prone to regression | Exploratory code |

**Rules:**
- Declare TDD upfront (prevents mock implementations)
- Commit tests before coding, don't modify during implementation
- Test in isolation (containers when possible)
- Iterate until green
- Verify all tests pass before completion

### Code Style

**Naming:**
- Booleans: `isEnabled`, `hasData`
- Constants: `MAX_RETRIES`
- Units: `timeoutMs`, `bufferKB`
- Collections: plural (`users`)
- Functions: `updateDatabase` (side effects), `getUser`/`findById` (queries), `isValid` (booleans)

**Comments:** Only WHY, never WHAT
- Allowed: non-obvious decisions, external requirements, algorithm rationale, workarounds
- Never: change tracking, obvious behavior, TODOs, syntax

**Rust:**
- Avoid allocations: `&str` not `String`, `&[T]` not `Vec<T>`, no `.clone()` shortcuts
- Errors: `anyhow` (apps), `thiserror` (libs)
- Async: sync for files, `tokio` for network, `rayon` for CPU
- Edition: "2024"

## Git & Releases

**Versioning:** Use commit hashes. Bump versions only when instructed. No jumps (0.0.1 → 1.0.0). 1.0.0 = production-ready.

**Release:** (wait for CI ✅)
1. Bump version, update docs → commit → push
2. `gh run watch` (wait for pass)
3. Tag: `git tag -a vX.Y.Z -m "Description" && git push --tags`
4. `gh release create vX.Y.Z --notes-file release_notes.md`
5. ASK before publishing (can't unpublish)

CI fails: delete tag/release, fix, restart

## Stack

**Languages:** Prefer Python, Rust, Go, Bun. Mojo: experimental (evaluate first).

**Versions:** Latest stable. Use ranges (`serde = "1.0"`), not pinned. Check: `mise list-all`, `cargo search`, crates.io/npm/PyPI.

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
