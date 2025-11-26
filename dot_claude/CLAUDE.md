# AI Agent Instructions

## Environment
- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## ai/ Directory

**Purpose:** AI session context - track state/decisions/research across sessions.

**Core Principle:** Session files (ai/ root) read EVERY session - keep minimal (<500 lines each). Reference files (subdirs) read ON DEMAND - zero token cost unless accessed.

### Files

| File | When | Purpose | Format |
|------|------|---------|--------|
| STATUS.md | ✅ Always | Current state, blockers (read FIRST) | Tables for metrics, bullets for learnings |
| TODO.md | ✅ Always | Active tasks only | Checkboxes, one-line + file links |
| DECISIONS.md | ✅ Recommended | Architectural decisions | Context → Decision → Rationale → Tradeoffs (table) |
| RESEARCH.md | ⚠️ If needed | Research index (summaries + pointers) | Topic → Finding → Link to details |
| KNOWLEDGE.md | ⚠️ If quirks | Permanent codebase quirks/gotchas | Table: Area → Knowledge → Impact → Discovered |
| PLAN.md | ⚠️ Optional | Strategic roadmap (ONLY if 3+ phases) | Tables: phases, dependencies, NO time estimates |

### Subdirectories

Create only when needed:

| Directory | When to Create | Contents |
|-----------|----------------|----------|
| research/ | Research becomes detailed OR multiple topics | Detailed research (exec summary if lengthy) |
| design/ | Formal specs needed (API, architecture) | Design specs (delete after implemented) |
| decisions/ | DECISIONS.md hard to navigate OR many superseded | Superseded/topic-split decisions |
| tmp/ | Always (with `echo '*' > ai/tmp/.gitignore`) | Temporary artifacts (never commit) |

### Workflow

**Start:** Read STATUS.md → TODO.md → AGENTS.md
**During:** Update TODO.md, document decisions, research in research/ if detailed
**End:** Update STATUS.md (state + learnings + commits) → Update TODO.md → Prune if needed

### Format Rules

**ALL ai/ files:** Tables/lists/structured, NOT prose. Answer first, evidence second.

❌ "After investigating caching, the team feels Redis would be good..."
✅ `**Decision**: Redis | **Why**: 10x faster, persistence | **Tradeoff**: Service dependency`

### Maintenance

**Prune when accumulating historical/completed content:**

| File | Delete |
|------|--------|
| STATUS.md | Old pivots, completed phases, resolved blockers |
| TODO.md | Completed tasks (no "Done" section) |
| DECISIONS.md | Move superseded → ai/decisions/superseded-YYYY-MM.md |
| RESEARCH.md | Move details → research/, keep index only |
| research/*.md, design/*.md | Delete when no longer relevant |

**Promote learnings:** Permanent rule → AGENTS.md | Permanent quirk → KNOWLEDGE.md | Transient → Delete

### Scaling

Start minimal, grow as needed:
- **Minimal:** STATUS.md + TODO.md
- **Standard:** Add DECISIONS.md + RESEARCH.md
- **Complex:** Add PLAN.md + research/ + design/

### AGENTS.md

**AGENTS.md = primary, CLAUDE.md → AGENTS.md = symlink**

**Belongs:** Build/test/deploy commands, coding standards, architecture, tech stack, verification steps, concrete code examples
**Doesn't belong:** Current issues (STATUS.md), learnings (STATUS.md), tactical roadmap (PLAN.md), detailed research (ai/research/)

Reference: github.com/nijaru/agent-contexts

## Workflow Rules

### Git
- Commit frequently, push regularly (no ask)
- **ASK before:** PRs, publishing packages, force ops, resource deletion
- Never force push to main/master
- Commit messages: Concise, focus on WHY not WHAT

### Files
- Delete directly (no archiving)
- `/tmp`: ephemeral only (delete after use)
- `ai/tmp/`: gitignored temporary artifacts

## Development

**Philosophy:** Do it right the first time. Research → understand → plan → implement.

### Code Quality

1. Research best practices first (state of the art)
2. Fix root cause, no workarounds
3. Production-ready: error handling, logging, validation
4. Follow existing patterns (read code before changing)
5. Update docs: README, docs/, ai/, AGENTS.md
6. Ask before breaking existing code/APIs

**Code exploration:** Read and understand relevant files before proposing edits. Do not speculate about unread code. If user references a file, inspect it before explaining or fixing.

**Over-engineering prevention:**
- Only make changes directly requested or clearly necessary
- Don't add features, refactor, or "improve" beyond what was asked
- Don't add error handling for impossible scenarios
- Don't create abstractions for one-time operations
- Minimum complexity for current task

### Testing & TDD

**Workflow:** Plan → Red → Green → Refactor → Validate

| Use TDD | Skip |
|---------|------|
| Systems (DBs, compilers), Performance (SIMD, algorithms), Complex logic | Docs, configs, typos, prototypes, simple scripts |

**Rules:** Declare upfront, commit tests before coding, don't modify during implementation

### Code Style

**Naming:** Concise, context-aware, proportional to scope
- Local: `count` | Package: `userCount`
- Omit redundant context: `Cache` not `LRUCache_V2`
- Booleans: `isEnabled` | Constants: `MAX_RETRIES` | Units: `timeoutMs`
- **Comparison variants:** Use clear, descriptive names (e.g., `process_sequential`, `process_parallel`, `process_simd`) not `process_v2`, `process_new`, `process_optimized`

**Comments:** Only WHY, never WHAT. No change tracking, TODOs, or obvious behavior.

**Rust:**
- Avoid allocations: `&str` not `String`, `&[T]` not `Vec<T>`
- Errors: `anyhow` (apps), `thiserror` (libs)
- Async: sync for files, `tokio` for network, `rayon` for CPU
- Edition: "2024"

## Git & Releases

**Versioning:**
- Use commit hashes for references
- Bump only when instructed
- Sequential: 0.0.1 → 0.0.2 → 0.1.0 → 1.0.0 (not 0.0.1 → 1.0.0)
- Semantics: 0.0.x = unstable | 0.1.0+ = production ready | 1.0.0 = proven in production

**Release:** (wait for CI ✅)
1. Bump version, update docs → commit → push
2. `gh run watch` (wait for pass)
3. `git tag -a vX.Y.Z -m "Description" && git push --tags`
4. `gh release create vX.Y.Z --notes-file release_notes.md`
5. **ASK before publishing** (can't unpublish)

## Stack

**Languages:** Python, Rust, Go, Bun. Mojo: evaluate first.

**Package versions:** Let manager choose unless pinning required
- ✅ `cargo add serde`, `uv add requests`, `bun add zod`
- ❌ `cargo add serde@1.0` (only pin for reproducibility, breaking changes, or explicit request)

**Python (uv):**
```bash
uv init && uv sync
uv add [pkg]
uv run python script.py
uv run ruff check . --fix
uvx ty check .
```

**JS/TS (bun):**
```bash
bun init
bun add [pkg]
bun run script.ts
bun test && bun build
```

**Go:**
- Formatter: `golines -m gofumpt` (unless project specifies otherwise)

**Versions:** `mise`
**UI:** lucide/heroicons, never emoji (unless requested)

**CLI Tools:** Prefer `rg`, `fd`, `sd`, `jq`/`yq`. Use `ast-grep` for AST manipulation.

## Standards

**Benchmarks & Comparisons:**
- Compare equivalent configs (same features, durability, workload)
- Report with full context: config, dataset size, environment, methodology
- Results must be reproducible reference for future sessions

---

**Version:** 2025-11-26 | **Reference:** github.com/nijaru/agent-contexts
