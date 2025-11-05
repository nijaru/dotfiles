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
- Project overview + pointers → Project `AGENTS.md`
  - Well-structured, scannable, no duplication of ai/ files
  - Create symlink: `ln -s AGENTS.md CLAUDE.md` (Claude Code compatibility)
- Dependencies + architecture + scope → `ai/PLAN.md` (optional, if 3+ phases/dependencies/deadlines)
- Current state + learnings → `ai/STATUS.md` (read FIRST)
- Tasks → `ai/TODO.md`
- Decisions → `ai/DECISIONS.md`
- Research → `ai/RESEARCH.md` + `ai/research/`
- Permanent docs → `docs/`

**Session workflow:**
- Read: PLAN.md (if exists) → STATUS.md → TODO.md → DECISIONS.md → RESEARCH.md
- Update ai/STATUS.md every session, NO artificial time tracking (WEEK*_DAY*.md files)
- Real dates okay for tracking: ANALYSIS_2025-11-05.md, BENCHMARK_NOV2025.md
- Update ai/PLAN.md on major pivots only. PLAN = what blocks what, technical approach, scope
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

Bug fixing:
- Fix properly on first attempt (investigate root cause)
- NO workarounds that need fixing later (wastes time, users may rely on incomplete fix)

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

NEVER: Change tracking (git does this), obvious behavior, TODOs, syntax explanations

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

## Version Selection

LLM training data is outdated. Always use latest stable versions:
- Languages: Check `mise list-all <tool>` for latest stable (Rust: edition "2024", not "2021")
- Dependencies: Use ranges (`serde = "1.0"`), not pinned (`serde = "1.0.150"`)
- Before suggesting versions: `cargo search <pkg>`, check crates.io/npm/PyPI for current latest
- Only pin for known compatibility issues (document why)

## Toolchains

**Python**: uv + mise (never pip)
- Tools: ruff (lint), ty (type check), vulture (find unused code)
- Commands: `uv init && uv sync`, `uv add [pkg]`, `uv run python script.py`
- `uv run ruff check . --fix`, `uvx ty check .`, `uvx vulture . --min-confidence 80`

**JavaScript/TypeScript**: bun + mise (never npm/yarn)
- Commands: `bun init`, `bun add [pkg]`, `bun run script.ts`, `bun test`, `bun build`

**Other**: mise for version management, consult official docs

**Web/CLI/TUI**: Use icon libraries (lucide, heroicons), NOT emoji characters in UI

## Language Selection

| Language | Use When | Avoid When |
|----------|----------|------------|
| **Python** | Scripts, ML/data, rapid prototyping, glue code | Performance critical, large codebases |
| **Rust** | CLI tools, systems, performance-critical, memory safety | Rapid prototyping, simple scripts |
| **Go** | Services/APIs, simple concurrency, easy deployment | Complex data structures, tight performance loops |
| **Mojo** | Python + performance (experimental, evaluate maturity first) | Production (too new) |

**Default**: Python for scripts/prototypes, Rust for tools/performance, Go for services.

## Programming Principles

**Avoid unnecessary allocations:**
- Think: copy or reference? Copy only when semantically needed
- Rust: `&str` not `String`, `&[T]` not `Vec<T>` for params, don't `.clone()` to bypass borrow checker
- Go: Pointers for large structs. Python: Views, generators

**Rust**: Error handling = `anyhow` (apps) / `thiserror` (libs). Async = sync for files, `tokio` for network, `rayon` for parallel CPU

## Modern CLI Tools

**Prefer tools with structured output and predictable behavior:**

| Task | Use | NOT | Why |
|------|-----|-----|-----|
| **Search code** | `rg` (ripgrep) | grep | Faster, respects .gitignore, better defaults |
| **Find files** | `fd` | find | Simpler syntax, predictable output |
| **JSON query** | `jq` | grep/awk | Proper JSON manipulation |
| **YAML query** | `yq` | grep/awk | Proper YAML manipulation (k8s configs) |
| **AST search** | `ast-grep` | grep/sed | Language-aware code search/refactor |
| **String replace** | `sd` | sed | Safer defaults, simpler syntax |
| **HTTP requests** | `xh`/`httpie` | curl | Structured JSON output |
| **Tabular data** | `miller` | awk | CSV/TSV/JSON processing |
| **File sync** | `sy` | rsync | 2-11x faster, JSON output, parallel (experimental) |

**Avoid human-centric tools:**
- `bat`, `eza`, `delta` - Syntax highlighting/colors don't help AI
- `fzf` - Interactive selection (AI can't interact)
- Use standard `cat`, `ls`, `diff` instead

**Structured shells for AI-driven tasks:**
- `nushell` - Everything is typed data (tables/records), not text
- Built-in JSON/CSV/YAML support, no text parsing needed
- Consider for complex data pipelines or AI automation scripts

**Custom Tools (Our Projects):**
- `stop --json` / `stop --csv` - Structured process monitoring (experimental)
- `sy` - Fast file sync, 2-11x faster than rsync (experimental)

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
