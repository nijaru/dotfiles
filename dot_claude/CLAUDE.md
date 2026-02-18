# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Dependencies:** Add via CLI (`cargo add`, `uv add`, `bun add`, `go get`)—resolves compatible versions. Never edit versions manually. Other manifest sections fine to edit.

**Python:** `uv` always. `uvx` one-off, `uv tool install` daily drivers. Lint/format: `ruff`. Types: `ty`. Never pip.

**TypeScript:** `bun` always. Lint: `oxlint`. Format: `oxfmt`. Test: `vitest` or `bun test`.

**Go:** `golines --base-formatter gofumpt`

**Rust:** `&str` > `String`, `&[T]` > `Vec<T>`. Errors: `anyhow` (apps), `thiserror` (libs). Async: `tokio` (network), `rayon` (CPU), sync (files). Edition 2024. `crate::` over `super::`. No `pub use` unless re-exporting for downstream. No global state (`lazy_static!`, `OnceCell`), prefer explicit context. Strong types over strings (enums, newtypes).

**Tools:**

- `mise` — runtime versions
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI
- `sg` / `ast-grep` — tree-safe refactors (prefer over regex for structural edits)

**Code search:** Semantic search for concepts, Grep for exact strings. Both require indexing (`colgrep init`, `og build`).

- `colgrep "query" ./path` — semantic code search (ColBERT). Hybrid: `colgrep -e "pattern" "query"`. Flags: `-k N` results, `-c` content, `--include "*.rs"`, `--json`
- `og "query" ./path` — semantic search (omengrep). `og file#func` (by name) | `og file:42` (by line). Flags: `-n N` results, `-t py,rs` type filter, `-l` files only

**Git tools:**

- `sem diff` — entity-level semantic diffs (functions, classes). `sem impact <entity>` | `sem blame <file>`
- `weave` — entity-level merge driver (configured globally, auto-used by git merge)

**Background jobs:** Use `jb` for commands expected to run >30s (builds, test suites, benchmarks, dev servers).

- `jb run "cmd" --follow` | `jb list` | `jb logs <id> --tail` | `jb stop <id>`
- `jb status <id>` | `jb wait <id>` | `jb retry <id>`

**Task tracking:** Use `tk` for multi-step or cross-session work—persists across compaction. Priority: `-p [0-4]` (1=urgent, 2=high, 3=med, 4=low).

- `tk add "title" -p 3` | `tk ls` | `tk ready` | `tk start <id>` | `tk done <id>`
- `tk show <id>` | `tk log <id> "msg"` | `tk block <id> <blocker>` | `tk reopen <id>`

**UI:** lucide/heroicons. No emoji unless requested.

**Search:**

| Tool                | Use                                   |
| ------------------- | ------------------------------------- |
| WebSearch           | Quick facts, current events (default) |
| Context7            | Library/framework docs                |
| Exa                 | Code examples, RAG, semantic search   |
| Parallel MCP search | Multi-hop research                    |

**Never use:** `parallel_createDeepResearch` - expensive, prefer manual search + synthesis.

## Development

**Philosophy:** Do it right first—workarounds become permanent. Fix what you touch. Research → understand → plan → implement.

**Design:** Clear > clever. Hard to explain = wrong abstraction. Small interfaces. A little copying over a little dependency.

**Performance:** Profile before optimizing.

**Problem-solving:** Reproduce before fixing. Question assumptions. If something seems off, it probably is—stop and verify. If stuck, reframe the problem.

**Quality:**

- Fix root cause, not symptoms
- Read code before changing it
- Update docs—record corrections in AGENTS.md to prevent repeats
- Ask before breaking APIs

**Errors:** Let errors propagate. Catch only to recover.

**Refactoring:** Clean breaks, not gradual migrations. When changing interfaces, signatures, or patterns:

- Replace completely in one commit—old code and all callers
- No version suffixes (V2, V3), no "old"/"legacy"/"new" markers
- No shims, adapters, or re-exports "for compatibility"
- No breadcrumbs: no `// moved to X`, `// removed`, `// deprecated` comments. Just delete.
- No deprecation unless explicitly instructed. If callers exist outside the repo, ask first.

**Review:** `/review` before major commits.

**Style:**

- **Naming:** Proportional to scope. Descriptive suffixes (`_batched`, `_async`) over version markers.
- **Comments:** Why, not what—only when non-obvious from code. Never narrate changes. No TODOs. No commented-out code.
- **Files:** Single concern. Tests separate.

**Testing:** Unit or e2e only. No mocks—they invent behaviors. Test failure paths, not just happy paths. Flaky tests are bugs. Verify tests actually ran.

**Benchmarks:** Compare equivalent configs. Report config, dataset, environment, methodology.

## Workflow

**Git:** Just commit—don't ask permission. Commit often. One logical change = one commit (function + callers, feature + tests). Don't split cohesive changes across commits or bundle unrelated ones. Push regularly. Only confirm before: PRs, publishing, force push, destructive ops. No force push main. Messages: concise WHY.

**Releases:** NEVER trigger without explicit approval. Wait for CI.

**Versions:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2).

## ai/ Directory

Persistent memory—survives compaction. Update BEFORE implementing.

| File         | Purpose                                                                                |
| ------------ | -------------------------------------------------------------------------------------- |
| STATUS.md    | Session state: current focus, external blockers, handoff notes. Pointers, not details. |
| DESIGN.md    | Architecture decisions and system design                                               |
| DECISIONS.md | Context → decision → rationale                                                         |
| SPRINTS.md   | Sprint plans (use `/sprint` to generate)                                               |

Root files read every session—keep minimal. Subdirs (research/, design/, review/, tmp/) on demand.

**Flow:** research/ → DESIGN.md → `/sprint` → SPRINTS.md → code → review/

**Format:** Tables/lists over prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Task Discipline

Use `tk` for all tasks—persists across compaction. Details in task logs, not STATUS.md.

**Session start:** Read STATUS.md → `tk ready` → `tk start <id>`

**Before investigating:** `tk show <id>` for existing logs, check ai/, git history. Never start fresh without checking.

**During work:** `tk log <id> "finding"` immediately—errors, root cause, file paths. Update STATUS.md when focus shifts, blockers emerge, or significant progress is made.

**Creating tasks:** `tk add "title" -d "context"`. Always include description.

**Completion:** `tk start` when beginning, `tk done` when complete. Stale status causes confusion.

## Subagents

For context isolation, parallelism, fresh perspective. ai/ files are shared memory.

| Agent        | Purpose                          | Persists to  |
| ------------ | -------------------------------- | ------------ |
| `researcher` | External knowledge, synthesis    | ai/research/ |
| `designer`   | Architecture, planning           | ai/design/   |
| `developer`  | Well-scoped implementation       | —            |
| `reviewer`   | Full validation (build/run/test) | ai/review/   |
| `profiler`   | Deep performance analysis        | ai/review/   |

**Model routing:** `opusplan` (default) uses Opus in plan mode, Sonnet for execution. Override subagent model: `CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6`.

**developer agent requires a spec** — not for open-ended tasks. Pass spec path or inline. If no spec, agent stops and reports.

**When to spawn:** Batch searches, large research → `researcher`. Significant changes → `reviewer`.

**Teams vs subagents:** Teams (TeamCreate) for coordinated parallel work with shared task lists and communication. Subagents for isolated one-off tasks.

**Before spawning:** Run build/test/lint once in the parent, include output in agent context. `cargo test` once beats `cargo test` × 3 reviewers.

**Avoid parallel agents when:**

- Results depend on each other (sequential by nature)
- One agent covers the scope—don't split reviewers across the same files
- The approach is unvalidated—confirm it works before parallelizing

**Context handoff:** Curate relevant context, don't dump history. Objectives at END (recency bias).

## Context Management

**Compact/new session at:** Feature complete · Switching codebase areas · Research synthesized · ~150k tokens. Proactively advise the user.

**Before compact:** Update STATUS.md, `tk done` completed tasks, `tk log` any uncommitted findings.

---

**Updated:** 2026-02-16 | github.com/nijaru/agent-contexts
