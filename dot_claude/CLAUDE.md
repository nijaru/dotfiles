# AI Agent Instructions

## System Context
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Critical Rules
- NO AI attribution in commits/PRs
  - Note: Claude Code system instructions add attribution by default - strip it manually if needed
- Ask before: opening PRs, **publishing packages to registries**, or destructive operations
- Commit frequently after each logical change, push regularly (no need to ask)
- Never force push to main/master
- NO archiving (delete files, git preserves history)
- Temp files: Fine during work, but clean up and remove when no longer useful
  - Test artifacts, logs, debug files, scratch scripts → delete after use
  - Never commit temp files unless explicitly needed for the project

## Where Information Belongs
**ai/ directory**: Agent working context for maintaining state across separate agent instances and conversations
- Global rules → `~/.claude/CLAUDE.md`
- Project overview → `AGENTS.md` (with `CLAUDE.md` → `AGENTS.md` symlink)
- Dependencies/architecture/scope → `ai/PLAN.md` (only if 3+ phases/dependencies)
- Current state → `ai/STATUS.md` (read FIRST at conversation start, update before exit)
- Tasks → `ai/TODO.md`
- Decisions → `ai/DECISIONS.md` (architecture, trade-offs)
- Research → `ai/RESEARCH.md` + `ai/research/`
- User docs → `docs/`

**Conversation workflow**: Read PLAN.md → STATUS.md → TODO.md → DECISIONS.md → RESEARCH.md, then update STATUS.md before conversation ends. Reference commits by hash (e.g., "Fixed in a1b2c3d").
Reference: github.com/nijaru/agent-contexts

## File Maintenance
Keep ai/ files focused on current/relevant info. Git preserves all history.

**STATUS.md**: Current state only - delete old pivots, completed phases, resolved blockers

**DECISIONS.md**: Active decisions affecting current codebase
- Superseded → ai/decisions/superseded-YYYY-MM.md
- Topic splits → ai/decisions/architecture.md, database.md, etc.

**TODO.md**: Active work only - delete completed tasks (no "Done" section)

**Anti-pattern**: No artificial time tracking (WEEK*_DAY*.md) - use git log for timeline

**Principle**: Prune when files contain substantial irrelevant/historical content

## ai/ Directory Format
Machine-optimized for cross-conversation context handoff. Use tables/lists, not prose. Answer first, evidence second. Exec summary if >500 lines.

## Code Standards
- Research best practices first (truly SOTA?)
- Test as you go
- Ask before breaking existing code (unless explicitly required)
- Fix root cause on first attempt, no workarounds
- Production-ready: error handling, logging, validation
- Follow existing patterns
- Update docs (README, docs/) and context (ai/, AGENTS.md)
- Verify tests pass

## Testing & Validation
Test in containers/isolated environments when possible.

## Naming Conventions
Variables: booleans `isEnabled`/`hasData`, constants `MAX_RETRIES`, with units `timeoutMs`/`bufferKB`, collections plural `users`
Functions: side effects `updateDatabase`, queries `getUser`/`findById`, booleans `isValid`/`hasPermission`

## Comments
NO comments unless explaining WHY (never WHAT): non-obvious decisions, external requirements, algorithm rationale, workarounds
Never: change tracking, obvious behavior, TODOs, syntax

## Git Workflow
Versions: Never bump (use commit hashes). Only when instructed. No jumps (0.0.1 → 1.0.0). 1.0.0 = production-ready.

## Release Process (only when instructed, wait for CI!)
1. Bump version, update docs
2. `git add -u && git commit -m "chore: bump version to X.Y.Z" && git push`
3. `gh run watch` (wait for all ✅)
4. `git tag -a vX.Y.Z -m "vX.Y.Z - Description" && git push --tags`
5. `gh release create vX.Y.Z --notes-file release_notes.md`
6. ASK before `cargo publish`/`npm publish`/`uv publish` (can't unpublish, wastes version numbers)
If CI fails: Delete tag/release, fix, restart

## Version Selection
Always latest stable. Check `mise list-all <tool>`, `cargo search`, crates.io/npm/PyPI
Use ranges (`serde = "1.0"`), not pinned. Rust: edition "2024"

## Toolchains
Python: `uv > pip/venv` (use uv, not pip or venv)
  Setup: `uv init && uv sync`, `uv add [pkg]`, `uv run python script.py`
  Tools: `uv run ruff check . --fix`, `uvx ty check .`, `uvx vulture . --min-confidence 80`
JS/TS: `bun init`, `bun add [pkg]`, `bun run script.ts`, `bun test`, `bun build`
Other: mise for version management
UI icons: Use icon libraries (lucide, heroicons), never emoji

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
