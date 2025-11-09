# AI Agent Instructions

## System Context
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Critical Rules
- NO AI attribution in commits/PRs (Claude Code adds by default - strip manually)
- Ask before: opening PRs, **publishing packages**, force operations, deleting resources
- Commit frequently, push regularly (no need to ask)
- Never force push to main/master
- Delete files directly (git preserves history, no archiving)
- Temp files: `/tmp` for ephemeral artifacts only. Context/state → `ai/` directory
  - Delete test artifacts/logs after use, never commit

## ai/ Directory
Agent state across sessions. Read at start, update before exit. **Storage:** `ai/` for context, `/tmp` for artifacts only.

**Structure:**
- `AGENTS.md` - Project overview (`CLAUDE.md` → `AGENTS.md` symlink)
- `ai/PLAN.md` - Dependencies/architecture (only if 3+ phases)
- `ai/STATUS.md` - Current state (read FIRST, update every session)
- `ai/TODO.md` - Active tasks
- `ai/DECISIONS.md` - Architecture decisions, trade-offs
- `ai/RESEARCH.md` + `ai/research/` - Research inputs
- `ai/design/` - Design outputs
- `docs/` - User documentation

**Workflow:** Read STATUS → work & commit (ref: "Fixed in a1b2c3d") → update STATUS before exit

**Format:** Tables/lists not prose. Answer first, evidence second. Exec summary if >500 lines.

**Maintenance:** Keep current only. Delete completed/superseded content.

| File | Keep | Delete | Archive |
|------|------|--------|---------|
| STATUS.md | Active blockers, current phase | Old pivots, resolved issues | - |
| DECISIONS.md | Active decisions | Resolved | `ai/decisions/superseded-YYYY-MM.md` |
| TODO.md | Pending tasks | Completed (no "Done" section) | - |

Anti-pattern: Time tracking files (WEEK*_DAY*.md)

Reference: github.com/nijaru/agent-contexts

## Code Standards
- Research best practices first (state of the art)
- Test as you go (containers/isolated when possible)
- Ask before breaking existing code
- Fix root cause, no workarounds
- Production-ready: error handling, logging, validation
- Follow existing patterns
- Update docs (README, docs/, ai/, AGENTS.md)
- Verify tests pass

## Testing
TDD provides binary success criteria, prevents drift during multi-step implementations. AI excels at test generation and rapid iteration.

**Workflow:** Plan → Red (failing tests) → Green (minimal pass) → Refactor → Validate

| Use TDD | Skip |
|---------|------|
| Systems: DBs, compilers, storage engines | Docs, configs, typos |
| Performance: SIMD, algorithms, hot paths | Prototypes, spikes |
| Production services with test infra | Simple scripts |
| Complex logic prone to regression | Exploratory code |

- Declare TDD upfront (prevents mock implementations)
- Commit tests before coding, don't modify during implementation
- Iterate until green

## Naming Conventions
Variables: booleans `isEnabled`/`hasData`, constants `MAX_RETRIES`, with units `timeoutMs`/`bufferKB`, collections plural `users`
Functions: side effects `updateDatabase`, queries `getUser`/`findById`, booleans `isValid`/`hasPermission`

## Comments
NO comments unless explaining WHY (never WHAT): non-obvious decisions, external requirements, algorithm rationale, workarounds
Never: change tracking, obvious behavior, TODOs, syntax

## Git Workflow
**Versioning**: Use commit hashes for references. Only bump versions when explicitly instructed. No jumps (0.0.1 → 1.0.0). 1.0.0 = production-ready.

## Release Process (only when instructed, wait for CI!)
1. Bump version, update docs
2. `git add -u && git commit -m "chore: bump version to X.Y.Z" && git push`
3. `gh run watch` (wait for ✅)
4. `git tag -a vX.Y.Z -m "vX.Y.Z - Description" && git push --tags`
5. `gh release create vX.Y.Z --notes-file release_notes.md`
6. ASK before publishing (can't unpublish)

CI fails: Delete tag/release, fix, restart

## Version Selection
Always latest stable. Check `mise list-all <tool>`, `cargo search`, crates.io/npm/PyPI
Use ranges (`serde = "1.0"`), not pinned. Rust: edition "2024"

## Toolchains
**Python:** `uv` only (not pip/venv)
- Setup: `uv init && uv sync`, `uv add [pkg]`, `uv run python script.py`
- Lint: `uv run ruff check . --fix`, `uvx ty check .`, `uvx vulture . --min-confidence 80`

**JS/TS:** `bun init`, `bun add [pkg]`, `bun run script.ts`, `bun test`, `bun build`
**Other:** mise for version management
**UI:** Icon libraries (lucide, heroicons), never emoji

## Language Selection
Prefer Python, Rust, Go, Bun. Mojo: experimental (evaluate maturity first)

## Programming Principles
Avoid allocations: reference over copy. Rust: `&str` not `String`, `&[T]` not `Vec<T>`, no `.clone()` shortcuts
Rust errors: `anyhow` (apps), `thiserror` (libs). Async: sync for files, `tokio` for network, `rayon` for CPU

## Modern CLI Tools

**Prefer tools with structured output and predictable behavior:**

| Task | Use | NOT | Why |
|------|-----|-----|-----|
| **Python packages** | `uv` | pip/venv | Faster, unified tool for deps + envs + scripts |
| **Search code** | `rg` (ripgrep) | grep | Faster, respects .gitignore, better defaults |
| **Find files** | `fd` | find | Simpler syntax, predictable output |
| **JSON query** | `jq` | grep/awk | Proper JSON manipulation |
| **YAML query** | `yq` | grep/awk | Proper YAML manipulation (k8s configs) |
| **AST search** | `ast-grep` | grep/sed | Language-aware code search/refactor |
| **String replace** | `sd` | sed | Safer defaults, simpler syntax |
| **HTTP requests** | `xh`/`httpie` | curl | Structured JSON output |
| **Tabular data** | `miller` | awk | CSV/TSV/JSON processing |
| **File sync** | `sy` | rsync | 2-11x faster, JSON output, parallel (experimental) |
| **Shell** | `nushell` | bash/zsh | Typed data, built-in JSON/CSV/YAML |

## Performance Claims
Never compare different abstraction levels. Before claiming "Nx faster": same features (ACID, durability), same workload, realistic data, 3+ runs, report median + caveats
Format: ✅ "X: 20x faster bulk inserts for sequential timestamps vs Y (both with durability). 10M rows. Random: 2-5x."
Stop if >50x speedup - verify abstraction level, features, data, and explain WHY
