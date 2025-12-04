# AI Agent Instructions

## Environment

- Mac: M3 Max, 128GB, Tailscale: `nick@apple`
- Fedora: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Package versions:** Let manager choose unless pinning required

- `cargo add serde`, `uv add requests`, `bun add zod`
- Only pin for reproducibility, breaking changes, or explicit request

**Python:** Always use `uv`. Exception: one-off stdlib-only scripts.

```bash
uv init && uv sync       # project setup
uv add [pkg]             # never pip install
uv run python script.py  # when in a uv project
uv run ruff check . --fix
uvx ty check .           # one-off tools
```

**TypeScript (Bun):**

```bash
bun init
bun add [pkg]
bun run script.ts
bun test && bun build
```

**Go:** Formatter: `golines --base-formatter gofumpt` (unless project specifies otherwise)

**Rust:**

- Avoid allocations: `&str` not `String`, `&[T]` not `Vec<T>`
- Errors: `anyhow` (apps), `thiserror` (libs)
- Async: sync for files, `tokio` for network, `rayon` for CPU
- Edition: 2024

**Tools:** `mise` (versions), `hhg "query" . --json` (relevance-ranked code search, returns full functions/classes)

**UI:** lucide/heroicons, never emoji (unless requested)

## Development

**Philosophy:** Do it right the first time. Research → understand → plan → implement.

### Code Quality

1. Research best practices first (state of the art)
2. Fix root cause, no workarounds
3. Production-ready: error handling, logging, validation
4. Follow existing patterns (read code before changing)
5. Update docs: README, docs/, ai/, AGENTS.md
6. Ask before breaking existing code/APIs

**NEVER propose changes to code you haven't read.**

### Code Style

**Naming:** Concise, context-aware, proportional to scope

- Local: `count` | Package: `userCount`
- Omit redundant context: `Cache` not `LRUCache_V2`
- Booleans: `isEnabled` | Constants: `MAX_RETRIES` | Units: `timeoutMs`
- No vague suffixes (`_v2`, `_new`)—use descriptive names (`_sequential`, `_parallel`)

**Comments:** Only WHY, never WHAT. No change tracking, TODOs, or obvious behavior.

**File organization:** Keep files focused.

- Before adding code: new module or existing file?
- Split when: mixing concerns or hard to navigate
- Tests: separate files, not inline

### Testing

**TDD Workflow:** Plan → Red → Green → Refactor → Validate

| Use TDD                                              | Skip                                             |
| ---------------------------------------------------- | ------------------------------------------------ |
| Systems (DBs, compilers), Performance, Complex logic | Docs, configs, typos, prototypes, simple scripts |

**Rules:** Declare upfront, commit tests before coding, don't modify during implementation

## Workflow

### Git

- Commit frequently, push regularly (no permission needed)
- **ASK before:** PRs, publishing packages, force ops, resource deletion
- Never force push to main/master
- Commit messages: Concise, focus on WHY not WHAT

### Releases

**Versioning:**

- Use commit hashes for references
- Bump only when instructed
- Sequential: 0.0.1 → 0.0.2 → 0.1.0 → 1.0.0 (not 0.0.1 → 1.0.0)
- Semantics: 0.0.x = unstable | 0.1.0+ = production ready | 1.0.0 = proven

**Release process:** (wait for CI ✅)

1. Bump version, update docs → commit → push
2. `gh run watch` (wait for pass)
3. `git tag -a vX.Y.Z -m "Description" && git push --tags`
4. `gh release create vX.Y.Z --notes-file release_notes.md`
5. **ASK before publishing** (can't unpublish)

### Files

- Delete directly (no archiving)
- `/tmp`: ephemeral only (delete after use)
- `ai/tmp/`: gitignored temporary artifacts

### Long-running Commands

- Avoid rapid polling; scale wait time with expected duration

## Task Tracking (Beads)

**Use `bd` for task management.** Dependency graphs + multi-session memory. Fallback: ai/TODO.md.

| Phase  | Commands                                                               |
| ------ | ---------------------------------------------------------------------- |
| Start  | `bd ready` (unblocked) ・ `bd list --status open`                      |
| Work   | `bd create "title" -t task -p 2` ・ `bd update X --status in-progress` |
| Depend | `bd dep add <task> <blocker>` (task depends on blocker)                |
| End    | `bd close X` ・ `bd sync` ・ Provide: "Continue bd-xxxx: [context]"    |

**Reference:** `bd show X` (details) ・ `bd dep tree X` (deps) ・ `bd list` (all)

## ai/ Directory

Cross-session project context. Root files read every session—keep minimal. Subdirs read on demand.

| File         | When            | Purpose                                         |
| ------------ | --------------- | ----------------------------------------------- |
| STATUS.md    | **Always**      | Current state, what's implemented (read FIRST)  |
| DESIGN.md    | **Recommended** | Architecture reference (NO task status markers) |
| DECISIONS.md | **Recommended** | Decisions: Context → Decision → Rationale       |
| ROADMAP.md   | Situational     | Phase timeline, links to beads                  |
| TODO.md      | Situational     | Tasks (fallback if no beads)                    |

**Separation of concerns:**

- **Beads** = task tracking (status, dependencies, individual work items)
- **DESIGN.md** = architecture reference (what, why, how—NOT status)
- **ROADMAP.md** = phase milestones (links to beads for task details)
- **STATUS.md** = current state snapshot (what's done vs not)

**Anti-pattern:** Don't put ✅/❌/In Progress in DESIGN.md. Architecture docs should be stable references, not task trackers.

**Subdirs:** Create when needed—research/, design/, tmp/ (gitignored)

**Workflow:** research/ (inputs) → DESIGN.md (synthesis) → design/ (component specs) → code

**Format:** Tables/lists, not prose. Answer first, evidence second.

- ❌ "After investigating, the team feels Redis would be good..."
- ✅ `**Decision**: Redis | **Why**: 10x faster | **Tradeoff**: dependency`

**Maintenance:** Prune completed/resolved content. Promote: permanent rules → AGENTS.md.

**Project config:** AGENTS.md as primary. For Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Standards

**Benchmarks & Comparisons:**

- Compare equivalent configs (same features, durability, workload)
- Report with full context: config, dataset size, environment, methodology
- Results must be reproducible reference for future sessions

---

**Version:** 2025-12 | **Reference:** github.com/nijaru/agent-contexts | github.com/steveyegge/beads
