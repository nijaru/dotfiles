# Agent Instructions

## Environment

| Machine | Specs                      | Tailscale     |
| ------- | -------------------------- | ------------- |
| Mac     | M3 Max, 128GB              | `nick@apple`  |
| Fedora  | i9-13900KF, 32GB, RTX 4090 | `nick@fedora` |

## Stack

**Languages:** Python, Rust, Go, TypeScript (Bun), Mojo — use expert skills for language-specific patterns.

**Dependencies:** Add via CLI (`cargo add`, `uv add`, `bun add`, `go get`). Never edit versions manually.

**Python:** `uv` always. `uvx` one-off, `uv tool install` daily drivers. Never pip. → `python-expert` skill

**TypeScript:** `bun` always. → `bun-expert` skill

**Rust:** Edition 2024. `anyhow` (apps), `thiserror` (libs). No global state. Strong types over strings. → `rust-expert` skill

**Go:** `goimports` → `golines --base-formatter gofumpt` → `go-expert` skill

**Tools:**

- `mise` — runtime versions
- `gh` — GitHub CLI
- `hf` — Hugging Face CLI
- `sg` / `ast-grep` — structural code transformations → `sg` skill
- `jb` — background jobs → `jb` skill
- `hyperfine` — benchmarking → `hyperfine` skill
- `nu-data` — data processing (jq/awk replacement) → `nu-data` skill

**Task tracking:** `tk` — persists across compaction. Priority: `-p [0-4]` (1=urgent, 2=high, 3=med, 4=low). → see Task Discipline

**Code search:** Default to `Grep` tool (rg) for exact strings. Use semantic tools for concept search — more token-efficient than scanning raw matches.

- `og "query" ./path` — semantic search (omengrep). Init: `og build`. Flags: `-n N`, `-t py,rs`, `-l`, `file#func`, `file:42`
- `colgrep "query" ./path` — semantic search (ColBERT). Init: `colgrep init`. Flags: `-k N`, `-c`, `--include "*.rs"`, `-e "pattern"` (hybrid)

**Git tools:**

- `sem diff` — entity-level semantic diffs. `sem impact <entity>` | `sem blame <file>`
- `weave` — entity-level merge driver (auto-used by git merge)

**Search:**

| Tool      | Use                                   |
| --------- | ------------------------------------- |
| WebSearch | Quick facts, current events (default) |
| Context7  | Library/framework docs                |
| Exa       | Code examples, RAG, semantic search   |

**UI:** lucide/heroicons. No emoji unless requested.

## Development

**Philosophy:** Do it right first—workarounds become permanent. Fix what you touch. Research → understand → plan → implement.

**Design:** Clear > clever. Hard to explain = wrong abstraction. Small interfaces. A little copying over a little dependency.

**Functional core, imperative shell:** Pure logic at the center; push side effects (IO, state, randomness) to the edges.

**Performance:** Profile before optimizing.

**Problem-solving:** Reproduce before fixing. Question assumptions. If something seems off, stop and verify. If stuck, reframe.

**Quality:**

- Fix root cause, not symptoms
- Read code before changing it
- Prefer the environment's built-in file-editing mechanism over ad hoc Python or shell rewrites; use scripts only when they are the right tool.
- Update docs—record corrections in AGENTS.md to prevent repeats
- Ask before breaking APIs

**Errors:** Let errors propagate. Catch only to recover.

**Refactoring:** Clean breaks, not gradual migrations. When changing interfaces, signatures, or patterns:

- Replace completely in one commit—old code and all callers
- No version suffixes (V2, V3), no "old"/"legacy"/"new" markers
- No shims, adapters, or re-exports "for compatibility"
- No breadcrumbs: no `// moved to X`, `// removed`, `// deprecated` comments. Just delete.
- No deprecation unless explicitly instructed. If callers exist outside the repo, ask first.
- When changing code, replace the affected implementation wholesale. Do not keep fallback paths, shims, compatibility branches, or workaround code unless explicit compatibility or deprecation is requested.
- Keep the rewrite scoped to the requested component or module; do not expand it into unrelated parts of the repo.

**Style:**

- **Naming:** Proportional to scope. Descriptive suffixes (`_batched`, `_async`) over version markers.
- **Comments:** Why, not what—only when non-obvious from code. Never narrate changes. No TODOs. No commented-out code.
- **Files:** Single concern. Tests separate.

**Testing:** Unit or e2e only. No mocks—they invent behaviors. Test failure paths, not just happy paths. Flaky tests are bugs. Verify tests actually ran.

**Benchmarks:** Compare equivalent configs. Report config, dataset, environment, methodology. → `hyperfine` skill

**Review:** `/review` before major commits.

## Workflow

**VCS:** Default to `git`. Use `jj` skill if `.jj/` directory is present.

**Git:** Commit immediately after finishing each coherent change set, without waiting for a reminder or permission. One logical change = one commit (function + callers, feature + tests). Push regularly. Confirm before: PRs, publishing, force push, destructive ops. No force push main.

**Commits:** `type(scope): msg` — scope mandatory. → `git-commit` skill for full spec.

**Releases:** NEVER trigger without explicit approval. Wait for CI.

**Versions:** Bump only when instructed. Sequential only (0.0.1 → 0.0.2).

## ai/ Directory

Persistent memory—survives compaction. Update before implementing. Stale files mislead—update or delete.

| File         | Purpose                                                                     |
| ------------ | --------------------------------------------------------------------------- |
| STATUS.md    | Current state, active blockers, index of topic files. Update every session. |
| DESIGN.md    | Architecture decisions and system design                                    |
| DECISIONS.md | Context → decision → rationale                                              |
| SPRINTS.md   | Sprint plans (use `/sprint` to generate)                                    |

Root files read every session—keep minimal. Subdirs (research/, design/, review/, tmp/) for topic-specific detail. Delete resolved items, don't mark done.

**Flow:** research/ → DESIGN.md → `/sprint` → SPRINTS.md → code → review/

**Format:** Tables/lists over prose. Answer first, evidence second.

**Project config:** AGENTS.md primary. Claude Code reads `.claude/CLAUDE.md` automatically—use `ln -s ../AGENTS.md .claude/CLAUDE.md` for your own repos. OSS/external repos often use `./CLAUDE.md`—follow whatever convention is present.

**Keeping ai/ and .tasks/ local:** Add to `.git/info/exclude` (not `.gitignore`). → `git-local-exclude` skill

## Task Discipline

Use `tk` for all tasks—persists across compaction. Details in task logs, not STATUS.md.

**Commands:** `tk add "title" -p 3 -d "context"` | `tk ls` | `tk ready` | `tk start <id>` | `tk done <id>` | `tk show <id>` | `tk log <id> "msg"` | `tk block <id> <blocker>` | `tk mv <id> <project>`

**Note:** Task IDs are opaque — when referencing a task ID, include the title unless it was just mentioned.

**Session start:** Read STATUS.md → `tk ready` → `tk start <id>`

**Before investigating:** `tk show <id>` for existing logs, check ai/, git history. Never start fresh without checking.

**During work:** `tk log <id> "finding"` immediately—errors, root cause, file paths. Update STATUS.md on focus shifts, blockers, significant progress.

**Completion:** `tk start` when beginning, `tk done` when complete. Stale status causes confusion.

## Coordinator Mindset

Operate as a **Coordinator** prioritizing synthesis and verification over mechanical action.

- **Synthesis Before Action:** Understand before acting. Synthesize findings into a plan in `ai/` for significant changes.
- **Selective Delegation:** Small, local tasks—do it yourself. Reserve subagents for parallel research, context isolation, or broad implementation.
- **Red-Green Verification:** Reproduce before fixing. Verify solution with tests.
- **Efficiency over Ceremony:** Avoid subagent "slop" and mirrored task tables.

## Subagent Delegation

For context isolation, parallelism, fresh perspective. `ai/` files are shared memory.

| Agent        | Purpose                          | Persists to  |
| ------------ | -------------------------------- | ------------ |
| `researcher` | External knowledge, synthesis    | ai/research/ |
| `designer`   | Architecture, planning           | ai/design/   |
| `developer`  | Well-scoped implementation       | —            |
| `reviewer`   | Full validation (build/run/test) | ai/review/   |
| `profiler`   | Deep performance analysis        | ai/review/   |

**Subagent model:** Override with `CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6`.

**`developer` requires a spec** — not for open-ended tasks. Pass spec path or inline. If no spec, agent stops and reports.

**When to spawn:** Batch searches, large research → `researcher`. Significant changes → `reviewer`.

**Teams vs subagents:** Teams (TeamCreate) for coordinated parallel work with shared task lists. Subagents for isolated one-off tasks.

**Before spawning:** Run build/test/lint once in the parent; include output in agent context.

**Avoid parallel agents when:** results depend on each other · one agent covers the scope · approach is unvalidated.

**Context handoff:** Curate relevant context, don't dump history. Objectives at END (recency bias).

## Context Management

**Compact/new session at:** Feature complete · Switching codebase areas · Research synthesized · ~150k tokens. Proactively advise user.

**Before compact:** Update ai/ files (especially STATUS.md), `tk done` completed tasks, `tk log` any uncommitted findings.

**Keep ai/ compact:** Flat structure by default; subdirectories only if complexity warrants.

## Code Standards (Single Pass)

Use during every `review` or `simplify` operation:

| Category        | Signal                                   | Fix                                                 |
| :-------------- | :--------------------------------------- | :-------------------------------------------------- |
| **Correctness** | Logic errors, edge cases, safety risks   | Fix root cause, add tests                           |
| **Complexity**  | Function > 40 lines, Nesting > 3         | Split, early returns, guard clauses                 |
| **Quality**     | Poor naming, inconsistent style          | Rename for intent, normalize style                  |
| **Efficiency**  | O(n^2) logic, unnecessary allocations    | Optimize algorithm, reuse abstractions              |
| **Cleanliness** | Duplication, dead code, verbose comments | Extract shared logic, delete dead code, clarify WHY |

---

**Updated:** 2026-04-02 | github.com/nijaru/agent-contexts
