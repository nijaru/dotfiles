# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo

**Packages:** Let manager choose. Pin only for reproducibility or breaking changes.

| Lang       | Setup                | Run                  | Format                             |
| ---------- | -------------------- | -------------------- | ---------------------------------- |
| Python     | `uv init && uv sync` | `uv run python x.py` | `uv run ruff check --fix .`        |
| TypeScript | `bun init`           | `bun run x.ts`       | `bun x biome format --write .`     |
| Go         | `go mod init`        | `go run .`           | `golines --base-formatter gofumpt` |
| Rust       | `cargo init`         | `cargo run`          | `cargo fmt`                        |
| Mojo       | —                    | `mojo run x.mojo`    | `mojo format`                      |

**Python:** Always `uv`. Never `pip install`. Exception: one-off stdlib-only scripts.

**Rust:** `&str` > `String`, `&[T]` > `Vec<T>`. Errors: `anyhow` (apps), `thiserror` (libs). Async: `tokio` (network), `rayon` (CPU), sync (files). Edition 2024.

**Tools:** `mise` (versions), `hhg "query" . --json` (semantic grep)

**UI:** lucide/heroicons. No emoji unless requested.

## Development

**Philosophy:** Do it right the first time—workarounds become permanent. Research → understand → plan → implement.

**Quality:**

1. Research best practices first
2. Fix root cause, no workarounds
3. Production-ready: error handling, logging, validation
4. Read code before changing—understand existing patterns
5. Update docs when relevant (README, ai/, AGENTS.md)
6. Ask before breaking APIs

**Style:**

- **Naming:** Proportional to scope. Local: `count`. Exported: `userCount`. No `_v2`/`_new`—use descriptive: `_batched`, `_async`.
- **Comments:** WHY only. No WHAT, no TODOs, no change tracking.
- **Files:** Keep focused. Split when mixing concerns.

## Workflow

**Git:**

- Commit frequently, push regularly
- Confirm before: PRs, publishing, force ops, resource deletion
- No force push to main/master
- Messages: concise, focus on WHY

**Releases:** Wait for CI ✅

| Step           | Command                                                  |
| -------------- | -------------------------------------------------------- |
| 1. Bump + docs | commit → push                                            |
| 2. Verify      | `gh run watch`                                           |
| 3. Tag         | `git tag -a vX.Y.Z -m "desc" && git push --tags`         |
| 4. Release     | `gh release create vX.Y.Z --notes-file release_notes.md` |
| 5. Publish     | **Confirm first**—can't unpublish                        |

**Versioning:** Sequential only. 0.0.x = unstable, 0.1.0+ = production, 1.0.0 = proven.

**Files:** Delete directly. `/tmp` ephemeral. `ai/tmp/` gitignored.

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

| File         | Purpose                          |
| ------------ | -------------------------------- |
| STATUS.md    | Current state (read first)       |
| DESIGN.md    | Architecture (no status markers) |
| DECISIONS.md | Context → Decision → Rationale   |
| ROADMAP.md   | Phase timeline, links to beads   |
| TODO.md      | Tasks (fallback if no beads)     |

**Subdirs:** research/, design/, tmp/ (gitignored). Create when needed.

**Format:** Tables/lists, not prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code: `ln -s ../AGENTS.md .claude/CLAUDE.md`

## Standards

**Benchmarks:** Compare equivalent configs. Report: config, dataset, environment, methodology. Reproducible.

---

**Version:** 2025-12 | github.com/nijaru/agent-contexts
