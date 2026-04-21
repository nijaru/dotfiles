---
name: ai-context
description: Full conventions for the ai/ persistent context system — file roles, index discipline, frontmatter spec, consolidation rules, and DECISIONS.md compaction. Use when operating on ai/ files or enforcing conventions mid-session.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# ai/ Context Conventions

Reference for operating within an established `ai/` directory. For initialization or audit/migration, use the `setup-ai` skill instead.

## Structure

```
ai/
├── README.md        # Index: pointers only, ~150 chars/entry, no content
├── STATUS.md        # Phase, focus, blockers — updated every session
├── DESIGN.md        # Current architecture — answers "what is it?"
├── DECISIONS.md     # Why decisions were made — Principles + Log sections
├── PLAN.md          # Active plan or sprint index (managed by /sprint)
├── research/        # Investigation docs
├── design/          # Detailed design docs
├── review/          # Review outputs
├── sprints/         # Sprint detail files (NN-name.md) — created by /sprint
└── tmp/             # Scratch (gitignored)
```

## File Roles

| File           | Purpose                                                                       | Update Rule                                                                   |
| :------------- | :---------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
| `README.md`    | Index only — pointers, ~150 chars/entry, no content                           | Immediately when any topic file is added/changed/deleted                      |
| `STATUS.md`    | Phase, active focus, blockers                                                 | Every session; on focus shifts and blockers                                   |
| `DESIGN.md`    | Current architecture — answers "what is it?"                                  | When architecture changes                                                     |
| `DECISIONS.md` | Why it is that way. **Principles** (distilled) + **Log** (recent ~20 entries) | Append to Log; compact when Log > ~20 entries                                 |
| `PLAN.md`      | Active plan. Flat doc or sprint index with `ai/sprints/NN-name.md` files      | Update as sprints progress; extract outcomes to DECISIONS/DESIGN then replace |

## Index Discipline

`README.md` is pointers only — format: `- [Title](path) — one-line hook`

- Write to any file → update `README.md` immediately. Index must stay synchronized.
- Verify links are live. Remove dead links.
- Don't persist derivable facts — if it's grep-able from code or git history, don't write it to `ai/`.
- `ai/` is hints, not truth — verify against code when it matters.

## Topic File Frontmatter

All files in `research/`, `design/`, `review/` must start with:

```yaml
---
date: YYYY-MM-DD
summary: one-line description
status: active | resolved | stale
---
```

Topic files in subdirs only get `README.md` entries if actively referenced by current work.

## DECISIONS.md Compaction

When Log section exceeds ~20 entries:

1. Read oldest Log entries
2. Identify recurring themes → distill into concise Principles at the top
3. Remove distilled entries from the Log
4. Keep recent ~10 entries verbatim

Run `/setup-ai` to do this automatically.

## Consolidation Rules

- **Merge before multiplying** — one focused file beats three overlapping ones.
- **Delete resolved files** — don't mark done, delete. `status: resolved` = candidate for deletion.
- **Stale threshold** — topic files unmodified for 3+ months with no `README.md` reference → verify relevance, delete if stale.
- **No derivable facts** — grep-able code facts don't belong in `ai/`.

## Workflow

`research/` → `DESIGN.md` → `/sprint` → `PLAN.md` → code → `review/`

**Format:** Tables/lists over prose. Answer first, evidence second.

## Project Config

`AGENTS.md` is primary in own repos. Symlink at repo root: `ln -s AGENTS.md CLAUDE.md`. OSS/external repos often use `./CLAUDE.md` — follow whatever convention is present.

**Keeping `ai/` and `.tasks/` local (not committed):**

```bash
echo 'ai/' >> .git/info/exclude
echo '.tasks/' >> .git/info/exclude
```

→ `git-local-exclude` skill for details.
