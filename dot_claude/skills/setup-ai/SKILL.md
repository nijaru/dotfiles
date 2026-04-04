---
name: setup-ai
description: Use when initializing or migrating AI agent context management (AGENTS.md, ai/ structure) for a project. Run on new repos to scaffold, and on existing repos to audit, consolidate, and migrate to current conventions.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Setup AI Context

Initialize a new project's AI context, or audit and migrate an existing one to current conventions. This is the canonical definition of the ai/ structure — run it on any repo that needs setup or cleanup.

## Detection Phase

Read in parallel:

- **Identity:** `git remote -v`, `README.md` (first paragraph)
- **Stack:** `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`
- **Existing context:** `ls -la ai/` if it exists, `AGENTS.md`, `CLAUDE.md`
- **Infrastructure:** `Makefile`, `justfile`, `.claude/settings.json`

Determine mode: **Init** (no ai/ exists) or **Audit** (ai/ exists).

## AGENTS.md / CLAUDE.md Configuration

| Scenario                 | Action                                                            |
| :----------------------- | :---------------------------------------------------------------- |
| Neither file exists      | Create `AGENTS.md`, symlink `.claude/CLAUDE.md` → `../AGENTS.md`  |
| Only `CLAUDE.md` at root | Rename to `AGENTS.md`, create symlink (leave as-is for OSS repos) |
| Both exist               | Merge to `AGENTS.md`, remove old `CLAUDE.md`, create symlink      |

## Topic File Frontmatter Standard

All files in `research/`, `design/`, `review/` must start with:

```yaml
---
date: YYYY-MM-DD
summary: one-line description
status: active | resolved | stale
---
```

## Mode: Init (New Repo)

### 1. Scaffold

```bash
mkdir -p ai/research ai/design ai/review ai/sprints ai/tmp
echo '*' > ai/tmp/.gitignore
tk init
```

Keep ai/ local (not committed):

```bash
echo 'ai/' >> .git/info/exclude
echo '.tasks/' >> .git/info/exclude
```

### 2. Create Root Files

**ai/README.md** — index only, pointers, no content:

```markdown
# AI Context Index

- [STATUS.md](STATUS.md) — current phase and active focus
- [DESIGN.md](DESIGN.md) — system architecture
- [DECISIONS.md](DECISIONS.md) — architectural decisions and rationale
- [PLAN.md](PLAN.md) — current active plan
```

**ai/STATUS.md:**

```markdown
# Status

**Phase:** initial setup
**Focus:** [current task]
**Blockers:** none
```

**ai/DESIGN.md:**

```markdown
# Design

## Architecture

[System overview]

## Components

[Component map]
```

**ai/DECISIONS.md:**

```markdown
# Decisions

## Principles

_Distilled from resolved decisions. Stable, load-bearing context._

## Log

_Recent decisions, ~20 entries max. Format: `[date] Context → Decision → Rationale`_
```

**ai/PLAN.md:**

```markdown
# Plan

[Current sprint/plan. One plan at a time — replace when complete. Extract outcomes to DECISIONS.md/DESIGN.md first.]
```

## Mode: Audit (Existing Repo)

Run when ai/ is out of sync, overlapping, or bloated. Work through these steps in order.

### 1. Inventory

```bash
find ai/ -name "*.md" | sort
```

Read all root files. Note which topic files have frontmatter and their status.

### 2. Structure Migration

Ensure current conventions are in place:

- `ai/README.md` exists and is index-only (pointers, ~150 chars/entry, no content)
- `ai/STATUS.md` has Phase / Focus / Blockers format
- `ai/PLAN.md` exists — if `ai/SPRINTS.md` is present, rename it and migrate content
- `ai/DECISIONS.md` has **Principles** + **Log** sections

### 3. Stale Detection

For each topic file in `research/`, `design/`, `review/`:

- Missing frontmatter → add it
- `status: resolved` or `status: stale` → candidate for deletion
- Last modified > 3 months with no reference in README.md → verify relevance, delete if stale

### 4. Consolidation

- Merge files covering the same topic. One focused file beats three overlapping ones.
- Delete resolved files — don't mark done, delete.
- Don't persist derivable facts — if it's grep-able from code or git history, remove it.

### 5. DECISIONS.md Compaction

If Log section exceeds ~20 entries:

1. Read oldest entries in the Log
2. Identify recurring themes → distill into concise Principles at the top
3. Remove distilled entries from the Log
4. Keep recent ~10 entries verbatim in the Log

### 6. Index Rebuild

Rewrite `ai/README.md` from scratch based on what actually exists after consolidation:

```markdown
# AI Context Index

- [Title](path) — one-line hook (~150 chars max)
```

Every file in ai/ root should have an entry. Topic files in subdirs get entries only if actively referenced.

## Verification

```bash
ls -la AGENTS.md .claude/CLAUDE.md   # verify symlink
tk ready                               # verify task tracking
ls -R ai/                              # verify structure
```

Check: README.md has no content (pointers only), DECISIONS.md has both sections, PLAN.md exists.

## Anti-Patterns

| Excuse                             | Reality                                                         |
| :--------------------------------- | :-------------------------------------------------------------- |
| "It's a small project"             | Inconsistent structure causes context drift in 3 sessions       |
| "I'll update README.md later"      | Stale index = agent loads wrong files = hallucinations          |
| "I'll keep old files just in case" | Dead files pollute context. Delete resolved work.               |
| "I'll mark this decision as done"  | Append Log + periodic distillation into Principles is correct   |
| "STATUS.md can hold the index too" | Index belongs in README.md. STATUS.md is operational state only |
