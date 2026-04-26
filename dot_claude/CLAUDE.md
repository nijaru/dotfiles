# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Dependencies:** Add via CLI (`cargo add`, `uv add`, `bun add`, `go get`). Never hand-edit versions.

**Languages & non-defaults:**

- **Python:** `uv` always (never pip). `uvx` for one-offs, `uv tool install` for daily drivers.
- **TypeScript:** `bun` always (never npm/node to run).
- **Rust:** Edition 2024. `anyhow` (apps), `thiserror` (libs). No global state. Strong types over strings.
- **Go:** `goimports` → `golines --base-formatter gofumpt`.
- **C++:** C++23, CMake + Ninja.
- **JUCE 8:** CMake-first, APVTS for parameters, real-time safe `processBlock`.

Language-specific patterns → matching expert skills (`python-expert`, `rust-expert`, `go-expert`, `bun-expert`, `cpp-expert`, `cmake-expert`, `juce-expert`, `zig-expert`, `mojo-syntax`).

**UI:** lucide/heroicons. No emoji unless requested.

## Tools

- `tk` — tasks, persists across compaction. → Task Discipline below
- `jb` — background jobs (prefer over `nohup`/`&`/`screen`) → `jb` skill
- `mise` — runtime versions
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI
- `sg` / `ast-grep` — structural refactors → `sg` skill
- `hyperfine` — benchmarking → `hyperfine` skill
- `nu` — typed data pipelines; prefer over `jq`/`awk` for multi-format, structured, or heterogeneous data → `nu-data` skill

Semantic search (`og`, `colgrep`) and entity-level git tools (`sem diff`, `sem impact`, `sem blame`) — load via their skills when a conceptual query or cross-entity analysis comes up; don't reach for them by default.

**Code search default:** `rg` (ripgrep) for exact strings (not `grep`). Reach for semantic search only when exact-string fails.

**Search hierarchy** (where available in harness):

| Tool      | Use                                   |
| --------- | ------------------------------------- |
| WebSearch | Quick facts, current events (default) |
| Context7  | Library/framework docs                |
| Exa       | Code examples, RAG, semantic search   |

## Development

**Philosophy:** Do it right first — workarounds become permanent. Fix what you touch. Research → understand → plan → implement.

**Design:** Clear > clever. Hard to explain = wrong abstraction. Small interfaces. A little copying beats a little dependency. Functional core, imperative shell — side effects at the edges.

**Problem-solving:** Reproduce before fixing. Question assumptions. If something seems off, stop and verify. If stuck, reframe.

**Quality:**

- Fix root cause, not symptoms.
- Read code before changing it.
- Prefer the harness's file-editing primitives over ad hoc shell rewrites (`sed`/`awk`/heredoc `cat >`). Scripts only when they're the right tool.
- Update docs — record recurring corrections in `AGENTS.md` to prevent repeats.
- Ask before breaking APIs.

**Restraint:** Do what the task requires, no more.

- No speculative features, abstractions, or helpers for hypothetical future needs. Three similar lines beat a premature abstraction.
- No defensive checks for conditions that can't happen. Trust internal code and framework guarantees; validate only at system boundaries (user input, external APIs, deserialized data).
- No scope creep. If you see unrelated issues, note them (task log, PR comment); don't fix them in the same change.
- Match existing conventions (imports, naming, error patterns, formatting) before introducing your own. Consistency beats personal preference.

**Errors:** Let them propagate. Catch only to recover. Never swallow — if you catch, either handle meaningfully or re-raise with context.

**Refactoring:** Clean breaks, not gradual migrations. When changing interfaces or patterns, replace wholesale — no shims, fallbacks, compatibility branches, or deprecation scaffolding unless explicitly requested.

**Style:**

- Naming proportional to scope. Descriptive suffixes (`_batched`, `_async`) over version markers.
- Comments: why, not what. Only when non-obvious from code. No TODOs. No commented-out code. Never narrate changes.
- Files: single concern. Tests separate.

**Testing:** Unit or e2e. No mocks of your own code — they invent behaviors. Fakes/stubs only at true external boundaries (paid APIs, hardware, non-deterministic third parties). Test failure paths, not just happy paths. Flaky tests are bugs. Verify tests actually ran.

**Performance:** Profile before optimizing. Benchmarks compare equivalent configs; report config, dataset, environment, methodology. → `hyperfine` skill.

**Finishing up:**

- Verify before declaring done — build, tests, or exercise the feature. "Looks right" is not verification. → `verification-before-completion` skill.
- For substantial changes (multi-file refactors, new features), run `/review` before the final commit of the set.
- Once it works, ask: _would I write this from scratch this way, knowing what I know now?_ If no, do a cleanup pass — debugging detours, defensive checks the final design doesn't need, names that reflect exploration not intent. → `rewrite` skill.

## Workflow

**User messages:** Do not treat every message as an interrupt. Use context to decide whether it means switch now, remember for later, or incorporate as background.

**VCS:** `git` by default. Use `jj` skill if `.jj/` is present.

**Commits — overrides harness default:** Commit immediately after each coherent change set without asking. One logical change = one commit (function + callers, feature + tests). Push regularly.

Format: `type(scope): msg` — scope mandatory. → `git-commit` skill.

**Confirm before:** PRs, publishing, force push, destructive ops. Never force-push protected or shared branches (`main`, `master`, `trunk`, `develop`, release branches).

**Releases:** Never trigger without explicit approval. Wait for CI.

**Versions:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2).

## ai/ Directory

Persistent project context — survives compaction. Update before implementing; stale files mislead. Load topic files relevant to the current task only, not all of `ai/`.

| File           | Purpose                                             | Update                                     |
| :------------- | :-------------------------------------------------- | :----------------------------------------- |
| `README.md`    | Index only — pointers, ~150 chars/entry, no content | Immediately on any add/change/delete       |
| `STATUS.md`    | Phase, focus, blockers                              | Every session                              |
| `DESIGN.md`    | Current architecture                                | On architecture changes                    |
| `DECISIONS.md` | Principles (distilled) + Log (recent ~20)           | Append to Log; compact when > 20           |
| `PLAN.md`      | Active plan or sprint index (managed by `/sprint`)  | As sprints progress; replace on completion |

Subdirs: `research/` · `design/` · `review/` · `sprints/` · `tmp/` (gitignored)

**Rules:** `ai/` is hints, not truth — verify against code. Don't persist derivable facts. Merge before multiplying; delete resolved files.

**Flow:** `research/` → `DESIGN.md` → `/sprint` → `PLAN.md` → code → `review/`

**Project config:** `AGENTS.md` primary. `ln -s AGENTS.md CLAUDE.md` for own repos. OSS repos often use `./CLAUDE.md` — follow what's present.

**Keeping `ai/` and `.tasks/` local:** `.git/info/exclude` → `git-local-exclude` skill. Full conventions → `ai-context` skill. Init/audit → `setup-ai` skill.

## Task Discipline

`tk` for all tasks — persists across compaction. Details in task logs, not `STATUS.md`.

**Commands:** `tk add "title" -p N -d "context"` | `tk ls` | `tk ready` | `tk start <id>` | `tk done <id>` | `tk show <id>` | `tk log <id> "msg"` | `tk block <id> <blocker>` | `tk mv <id> <project>`

Priority `-p` (1–4): 1=urgent, 2=high, 3=med, 4=low. Optional — omit if unsure.

**Task IDs are opaque** — when referencing one, include the title unless it was just mentioned.

**Session start:** `ai/README.md` → `ai/STATUS.md` → `tk ready` → `tk start <id>`.

**Before investigating:** Never start fresh. Check `tk show <id>`, `ai/`, and git history first.

**During work:** `tk log <id> "finding"` immediately — errors, root cause, file paths. Update `ai/STATUS.md` on focus shifts, blockers, real progress.

**Completion:** `tk start` when beginning, `tk done` when complete. Stale status causes confusion.

## Subagent Delegation

Applies to harnesses with subagents (Claude Code, Droid). Subagents provide context isolation, parallelism, and fresh perspective. `ai/` files are the shared memory between parent and agent.

| Agent        | Purpose                          | Persists to    |
| ------------ | -------------------------------- | -------------- |
| `researcher` | External knowledge, synthesis    | `ai/research/` |
| `designer`   | Architecture, planning           | `ai/design/`   |
| `developer`  | Well-scoped implementation       | —              |
| `reviewer`   | Full validation (build/run/test) | `ai/review/`   |
| `profiler`   | Deep performance analysis        | `ai/review/`   |

**Rules:**

- **Synthesis before delegation.** Understand the problem yourself first; synthesize into a plan in `ai/` before spawning agents for significant changes.
- **`developer` requires a written spec** — not for open-ended tasks. If no spec, it stops and reports.
- **Small/local tasks: do them yourself.** Reserve subagents for parallel research, context isolation, or scoped implementation.
- **Before spawning:** run build/test/lint once in the parent; include the output in the agent brief.
- **Curate context; don't dump history.** Objectives at the end of the brief.
- **Avoid parallel agents when** results depend on each other · one agent covers the scope · the approach is unvalidated.
- **Subagent model override:** `CLAUDE_CODE_SUBAGENT_MODEL=<model-id>` (typically current Sonnet for faster/cheaper runs).

Teams (where available) coordinate multiple agents on a shared task list; subagents are isolated one-offs.

## Context Management

**Compact or start a new session at:** feature complete · switching codebase areas · research synthesized · approaching context pressure (varies by model — watch for degrading recall, not a fixed token count). Proactively advise the user.

**Before compact:** update `ai/STATUS.md` and `ai/README.md`, `tk done` completed tasks, `tk log` any uncommitted findings.

**Keep `ai/` lean:** root files minimal; subdirs (`research/`, `design/`, `review/`) stay empty until needed.

## Code Standards

Apply during every `review` or `simplify` pass:

| Category        | Watch for                                 | Fix                                       |
| :-------------- | :---------------------------------------- | :---------------------------------------- |
| **Correctness** | Logic errors, edge cases, safety risks    | Fix root cause, add tests                 |
| **Complexity**  | Long functions, deep nesting              | Split, early returns, guard clauses       |
| **Quality**     | Poor naming, inconsistent style           | Rename for intent, normalize              |
| **Efficiency**  | Accidental O(n²), unnecessary allocations | Better algorithm, reuse abstractions      |
| **Cleanliness** | Duplication, dead code, verbose comments  | Extract shared logic, delete, clarify WHY |

---

**Updated:** 2026-04-24 | github.com/nijaru/agent-contexts
