# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Packages:** Let manager choose. Pin only for reproducibility or breaking changes.

**Python:** Always `uv` for dependencies. `uvx` for one-off CLI tools, `uv tool install` for daily drivers. Never `pip install`.

**Go:** Formatter: `golines --base-formatter gofumpt`

**Rust:** `&str` > `String`, `&[T]` > `Vec<T>`. Errors: `anyhow` (apps), `thiserror` (libs). Async: `tokio` (network), `rayon` (CPU), sync (files). Edition 2024.

**Tools:** `mise` (versions), `hhg` (semantic—finds implementations). Grep for exact text.

**Background Jobs:** `jb run "cmd"` for persistent processes (dev servers, builds, watchers). Survives disconnects. `--follow` streams output. `list`, `logs [--follow]|stop|wait|status|retry <id>`, `clean`.

**CLIs:** `gh` (GitHub), `hf` (Hugging Face).

**UI:** lucide/heroicons. No emoji unless requested.

**Search:**

| Tool         | When                                             |
| ------------ | ------------------------------------------------ |
| WebSearch    | Quick facts, current events, simple lookups      |
| Context7     | Library/framework docs (first choice)            |
| Exa          | Code examples, RAG, semantic "find similar"      |
| Parallel     | Complex research, multi-hop (2x accuracy)        |
| research-web | Deep research → agent persists to `ai/research/` |

Default to WebSearch. Use `research-web` agent when findings should persist or query is complex.

## Development

**Philosophy:** Do it right the first time—workarounds become permanent. Research → understand → plan → implement.

**Quality:**

1. Research best practices first
2. Fix root cause, no workarounds
3. Production-ready: error handling, logging, validation
4. Read code before changing—understand existing patterns
5. Update docs when relevant (README, ai/, AGENTS.md)
6. Ask before breaking APIs
7. Review after features/refactors:
   - Auto: spawn `code-review` subagent with context summary
   - Manual: `/review` for comprehensive check before commits

**Style:**

- **Naming:** Proportional to scope. Local: `count`. Exported: `userCount`. No `_v2`/`_new`—use descriptive: `_batched`, `_async`.
- **Comments:** WHY only. No WHAT, no TODOs, no change tracking.
- **Files:** Keep focused. Split when mixing concerns. Tests: separate files.

## Workflow

**Git:**

- Commit frequently, push regularly
- Confirm before: PRs, publishing, force ops, resource deletion
- No force push to main/master
- Messages: concise, focus on WHY

**Releases:** NEVER trigger release/publish workflows without explicit user approval. Wait for CI. Can't unpublish.

**Versioning:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2, not 0.0.1 → 1.0.0). Reference code by commit hash.

**Long-running commands:** Use `jb` for persistent processes. Avoid rapid polling; scale wait time with expected duration.

## Task Tracking (Beads)

Use `bd` for tasks. Fallback: ai/TODO.md.

| Phase  | Commands                                                               |
| ------ | ---------------------------------------------------------------------- |
| Start  | `bd ready` ・ `bd list --status open`                                  |
| Work   | `bd create "title" -t task -p 2` ・ `bd update X --status in-progress` |
| Depend | `bd dep add <task> <blocker>`                                          |
| End    | `bd close X` ・ `bd sync` ・ Provide: "Continue bd-xxxx: [context]"    |

## ai/ Directory

Cross-session context. Root files every session—keep minimal.

| File         | When        | Purpose                          |
| ------------ | ----------- | -------------------------------- |
| STATUS.md    | Always      | Current state (read first)       |
| DESIGN.md    | Recommended | Architecture (no status markers) |
| DECISIONS.md | Recommended | Context → Decision → Rationale   |
| ROADMAP.md   | Situational | Phase timeline, links to beads   |
| TODO.md      | Situational | Tasks (fallback if no beads)     |

**Update Rules (always follow):**

| Trigger                  | Action                                               |
| ------------------------ | ---------------------------------------------------- |
| Architecture change      | Update DESIGN.md immediately                         |
| Made a tradeoff decision | Append to DECISIONS.md with date, context, rationale |
| Task completed/blocked   | Update STATUS.md                                     |
| Before `/compact`        | Update STATUS.md with current state                  |
| Session ending           | Run `/save`                                          |

**Workflow:** research/ (inputs) → DESIGN.md (synthesis) → design/ (specs) → code

**Anti-pattern:** No ✅/❌/In Progress in DESIGN.md—architecture docs are stable references, not task trackers.

**Format:** Tables/lists, not prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Context Management

**Main agent does most work**—user has visibility, can course-correct.

**Prompt user to compact at:**

- Feature/milestone complete
- Before switching codebase areas
- After research synthesized
- Approaching ~100k tokens

**Before compact:** Update ai/STATUS.md with current state.

**Subagents only for autonomous work:**

| Use Case       | Subagent       | Why                                      |
| -------------- | -------------- | ---------------------------------------- |
| Deep research  | `research-web` | Returns summary, persists to ai/research |
| Code review    | `code-review`  | Returns findings, unbiased fresh eyes    |
| Isolated fixes | `general`      | Well-defined, low-risk, no user input    |

**Don't use subagents for:** Features needing user input, exploratory work, interdependent tasks.

## Standards

**Benchmarks:** Compare equivalent configs. Report: config, dataset, environment, methodology. Reproducible.

---

**Updated:** 2025-12-23 | github.com/nijaru/agent-contexts
