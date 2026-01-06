# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Packages:** Use CLI tools (`cargo add`, `uv add`, `go get`, `bun add`), not manual manifest edits. Pin versions only for reproducibility or known breaking changes.

**Python:** `uv` always. `uvx` one-off, `uv tool install` daily drivers. Lint/format: `ruff`. Types: `ty`. Never pip.

**TypeScript:** `bun` always. Lint: `oxlint`. Format: `oxfmt`. Test: `vitest` or `bun test`.

**Go:** `golines --base-formatter gofumpt`

**Rust:** `&str` > `String`, `&[T]` > `Vec<T>`. Errors: `anyhow` (apps), `thiserror` (libs). Async: `tokio` (network), `rayon` (CPU), sync (files). Edition 2024. `crate::` over `super::`. No `pub use` unless re-exporting for downstream. No global state (`lazy_static!`, `OnceCell`), prefer explicit context. Strong types over strings (enums, newtypes).

**Tools:**

- `mise` — runtime versions
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI
- `sg` / `ast-grep` — tree-safe refactors (prefer over regex for structural edits)

**Code search:** Use `hhg` (semantic) for concepts, Grep for exact strings.

- `hhg "query" ./path` | `hhg file#func` (by name) | `hhg file:42` (by line)

**Background jobs:** Use `jb` for commands expected to run >30s (builds, test suites, benchmarks, dev servers).

- `jb run "cmd" --follow` | `jb list` | `jb logs <id> --tail` | `jb stop <id>`

**Task tracking:** Use `tk` for multi-step or cross-session work—persists across compaction.

- `tk add "title"` | `tk ls` | `tk ready` | `tk start <id>` | `tk done <id>`

**UI:** lucide/heroicons. No emoji unless requested.

**Search:**

| Tool                | Use                                   |
| ------------------- | ------------------------------------- |
| WebSearch           | Quick facts, current events (default) |
| Context7            | Library/framework docs                |
| Exa                 | Code examples, RAG, semantic search   |
| Parallel MCP search | Multi-hop research                    |

## Development

**Philosophy:** Do it right first—workarounds become permanent. Research → understand → plan → implement.

**Quality:** Research first · Fix root cause · Production-ready (errors, logging, validation) · Read before changing · Update docs (README, ai/, AGENTS.md) · Ask before breaking APIs

**Upgrades:** No deprecation—remove old code and update all usages in the same change. Only deprecate if explicitly instructed.

**Corrections:** Update AGENTS.md when corrected on non-obvious project patterns—prevents repeat mistakes.

**Review:** Consider `reviewer` for significant changes. `/review` before major commits.

**Style:**

- **Naming:** Proportional to scope. No `_v2`/`_new`—use `_batched`, `_async`.
- **Comments:** WHY only. No WHAT, no TODOs.
- **Files:** Single concern. Tests separate.
- **No breadcrumbs:** When deleting/moving code, just remove it. No `// moved to X`, `// removed`, `// deprecated`.

**Testing:** Unit or e2e only. No mocks—they invent behaviors that hide real bugs.

**Benchmarks:** Compare equivalent configs. Report config, dataset, environment, methodology.

## Workflow

**Git:** Proactively commit after completing logical units of work—don't wait to be asked. Push regularly. Confirm before PRs/publishing/force ops. No force push main. Messages: concise WHY.

**Releases:** NEVER trigger without explicit approval. Wait for CI.

**Versions:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2).

## ai/ Directory

Persistent memory—survives compaction. Update BEFORE implementing.

**Todos/tasks:** Use `tk`, never STATUS.md.
**Blockers/session notes:** STATUS.md
**Architecture:** DESIGN.md
**Decisions:** DECISIONS.md (context → decision → rationale)

Root files read every session—keep minimal. Subdirs (research/, design/, review/, tmp/) on demand.

**Flow:** research/ → DESIGN.md → design/ → code → review/

**Format:** Tables/lists over prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Subagents

For context isolation, parallelism, fresh perspective. ai/ files are shared memory.

| Agent        | Purpose                          | Persists to  |
| ------------ | -------------------------------- | ------------ |
| `researcher` | External knowledge, synthesis    | ai/research/ |
| `designer`   | Architecture, planning           | ai/design/   |
| `developer`  | Well-scoped implementation       | —            |
| `reviewer`   | Full validation (build/run/test) | ai/review/   |
| `profiler`   | Deep performance analysis        | ai/review/   |

**When to spawn:** Batch searches, large research → `researcher`. Significant changes → `reviewer`.

**Context handoff:** Curate relevant context, don't dump history. Objectives at END (recency bias).

## Context Management

**Prompt user to compact at:** Feature complete · Switching codebase areas · Research synthesized · ~100k tokens

**Before compact:** Update STATUS.md, `tk done` completed tasks.

---

**Updated:** 2026-01-06 | github.com/nijaru/agent-contexts
