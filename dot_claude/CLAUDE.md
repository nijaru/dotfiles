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
- `hhg` — semantic code search (finds implementations, definitions). Use for "where is X implemented?" Grep for exact text.
- `jb` — background jobs that survive disconnects. `jb run "cmd"` starts, `--follow` streams output. Subcommands: `list`, `logs [--follow]`, `stop`, `wait`, `status`, `retry <id>`, `clean`.
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI

**UI:** lucide/heroicons. No emoji unless requested.

**Search:**

| Tool         | Use                                        |
| ------------ | ------------------------------------------ |
| WebSearch    | Quick facts, current events (default)      |
| Context7     | Library/framework docs                     |
| Exa          | Code examples, RAG, semantic search        |
| Parallel     | Complex multi-hop research (2x accuracy)   |
| research-web | Deep research → persists to `ai/research/` |

## Development

**Philosophy:** Do it right first—workarounds become permanent. Research → understand → plan → implement.

**Quality:** Research first · Fix root cause · Production-ready (errors, logging, validation) · Read before changing · Update docs (README, ai/, AGENTS.md) · Ask before breaking APIs

**Review:** Auto-spawn `code-review` after features. Manual `/review` before commits.

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

Cross-session context. Read root files every session.

| File         | When        | Purpose                          |
| ------------ | ----------- | -------------------------------- |
| STATUS.md    | Always      | Current state (read first)       |
| DESIGN.md    | Recommended | Architecture (no status markers) |
| DECISIONS.md | Recommended | Context → Decision → Rationale   |
| ROADMAP.md   | Situational | Phase timeline, links to beads   |
| TODO.md      | Situational | Tasks (fallback if no beads)     |

**Update triggers:**

| Event                  | Action                              |
| ---------------------- | ----------------------------------- |
| Architecture change    | Update DESIGN.md                    |
| Tradeoff decision      | Append DECISIONS.md (date, context) |
| Task completed/blocked | Update STATUS.md                    |
| Before `/compact`      | Update STATUS.md                    |
| Session ending         | Run `/save`                         |

**Flow:** research/ → DESIGN.md → design/ → code

**Anti-pattern:** No ✅/❌ in DESIGN.md—architecture is stable, not a tracker.

**Format:** Tables/lists over prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Context Management

Main agent does most work—user has visibility, can course-correct.

**Prompt user to compact at:** Feature complete · Switching codebase areas · Research synthesized · ~100k tokens

**Before compact:** Update ai/STATUS.md.

**Subagents for autonomous work only:**

| Use Case       | Agent          | Why                                   |
| -------------- | -------------- | ------------------------------------- |
| Deep research  | `research-web` | Persists findings to ai/research/     |
| Code review    | `code-review`  | Unbiased, fresh eyes                  |
| Isolated fixes | `general`      | Well-defined, low-risk, no user input |

**Not for subagents:** Features needing input, exploratory work, interdependent tasks.

---

**Benchmarks:** Compare equivalent configs. Report config, dataset, environment, methodology.

**Updated:** 2025-12-23 | github.com/nijaru/agent-contexts
