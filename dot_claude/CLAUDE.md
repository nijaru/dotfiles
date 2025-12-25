# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Packages:** Use CLI tools (`cargo add`, `uv add`, `go get`, `bun add`), not manual manifest edits. Pin versions only for reproducibility or known breaking changes.

**Python:** `uv` always. `uvx` one-off, `uv tool install` daily drivers. Never pip.

**Go:** `golines --base-formatter gofumpt`

**Rust:** `&str` > `String`, `&[T]` > `Vec<T>`. Errors: `anyhow` (apps), `thiserror` (libs). Async: `tokio` (network), `rayon` (CPU), sync (files). Edition 2024.

**Tools:**

- `mise` — runtime versions
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI

**hhg** (semantic code search) — finds implementations by concept, not just text. Use for "where is X implemented?", "find auth code", "how does Y work". Grep/ripgrep for exact strings. `/hhg` for full reference.

```bash
hhg build ./src              # Index first (auto-updates on search)
hhg "auth flow" ./src        # Semantic search
hhg file.py#function         # Find similar code by name
hhg file.py:42               # Find similar code by line
```

**jb** (background jobs) — long-running commands that survive disconnects. Use for builds >30s, test suites, dev servers. `/jb` for full reference.

```bash
jb run "cmd"                 # Start, returns ID
jb run "cmd" --follow        # Stream output (resilient)
jb list                      # Show jobs
jb logs <id> --tail          # Recent output
jb stop/wait/retry <id>      # Control jobs
```

**UI:** lucide/heroicons. No emoji unless requested.

**Search:**

| Tool      | Use                                      |
| --------- | ---------------------------------------- |
| WebSearch | Quick facts, current events (default)    |
| Context7  | Library/framework docs                   |
| Exa       | Code examples, RAG, semantic search      |
| Parallel  | Complex multi-hop research (2x accuracy) |

## Development

**Philosophy:** Do it right first—workarounds become permanent. Research → understand → plan → implement.

**Quality:** Research first · Fix root cause · Production-ready (errors, logging, validation) · Read before changing · Update docs (README, ai/, AGENTS.md) · Ask before breaking APIs

**Review:** Consider `reviewer` for significant changes. `/review` before major commits.

**Style:**

- **Naming:** Proportional to scope. No `_v2`/`_new`—use `_batched`, `_async`.
- **Comments:** WHY only. No WHAT, no TODOs.
- **Files:** Single concern. Tests separate.

## Workflow

**Git:** Commit often, push regularly. Confirm before PRs/publishing/force ops. No force push main. Messages: concise WHY.

**Releases:** NEVER trigger without explicit approval. Wait for CI.

**Versions:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2).

## Task Tracking

`bd` (beads) for task management across sessions. Fallback: ai/TODO.md.

| Phase | Commands                                                               |
| ----- | ---------------------------------------------------------------------- |
| Start | `bd ready` ・ `bd list --status open`                                  |
| Work  | `bd create "title" -t task -p 2` ・ `bd update X --status in-progress` |
| End   | `bd close X` ・ `bd sync` ・ Provide: "Continue bd-xxxx: [context]"    |

## ai/ Directory

Cross-session context. Root files read every session—keep minimal. Subdirs read on demand.

| File         | When        | Purpose                          |
| ------------ | ----------- | -------------------------------- |
| STATUS.md    | Always      | Current state (read first)       |
| DESIGN.md    | Recommended | Architecture (no status markers) |
| DECISIONS.md | Recommended | Context → Decision → Rationale   |
| ROADMAP.md   | Situational | Phase timeline, links to beads   |
| TODO.md      | Situational | Tasks (fallback if no beads)     |

**Subdirs:** research/, design/, review/, tmp/ (gitignored) — loaded on demand

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

**Context handoff:** Curate relevant context, don't dump history. Put objectives at END (recency bias).

## Context Management

**Prompt user to compact at:** Feature complete · Switching codebase areas · Research synthesized · ~100k tokens

**Before compact:** Update ai/STATUS.md.

---

**Benchmarks:** Compare equivalent configs. Report config, dataset, environment, methodology.

**Updated:** 2025-12-25 | github.com/nijaru/agent-contexts
