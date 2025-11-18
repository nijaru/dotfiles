Initialize AI agent context management for project.

**Reference:** github.com/nijaru/agent-contexts PRACTICES.md
**Philosophy:** Session files (<500 lines, current only) + Reference subdirs (on-demand) = token efficiency

## Execution Guidelines

- Run independent operations in parallel (file reads, git commands, directory creation)
- Use extended reasoning for complex projects (>100 files, multi-phase)
- Research current best practices before implementing (research/ → design/ → code)
- Apply detection rigorously: fill ALL detected info, [TBD] only if truly cannot detect

## 1. Detect Project Info

| Item | Detection Sources | Parallel Read |
|------|------------------|---------------|
| Name | git remote, package.json, Cargo.toml, pyproject.toml, go.mod | ✓ |
| Language | File extensions (.rs/.py/.ts), package managers | ✓ |
| Framework | package.json deps, Cargo.toml deps, imports | ✓ |
| Commands | package.json scripts, Makefile, Cargo.toml, justfile | ✓ |
| Description | README first paragraph | ✓ |
| Complexity | README/docs for: "phases", "milestones", "roadmap", "v1/v2" | ✓ |
| Existing config | AGENTS.md, CLAUDE.md (check symlink target) | ✓ |
| Claude Code | .claude/commands/, settings.json, settings.local.json | ✓ |

**Action:** Read all sources in parallel. Consolidate detected info.

## 2. Handle Existing Config

| Scenario | Action |
|----------|--------|
| Neither exists | Create AGENTS.md + symlink CLAUDE.md → AGENTS.md |
| Only AGENTS.md | Add symlink CLAUDE.md → AGENTS.md |
| Only CLAUDE.md | Rename → AGENTS.md + create symlink |
| CLAUDE.md → AGENTS.md | Update content if needed |
| Both files | Merge → AGENTS.md, remove old CLAUDE.md, create symlink |
| CLAUDE.md → elsewhere | Ask user before modifying |

## 3. Determine Structure

| Project Complexity | Files | Subdirs | PLAN.md |
|-------------------|-------|---------|---------|
| Minimal (<1mo) | STATUS.md, TODO.md | research/, design/, decisions/ | ⊘ Skip |
| Standard (1-6mo) | +DECISIONS.md, RESEARCH.md | research/, design/, decisions/ | ⊘ Skip |
| Complex (6+mo) | +PLAN.md | research/, design/, decisions/ | ✓ Create |

**PLAN.md criteria:** 3+ phases OR critical dependencies OR external deadline
**Subdirs:** Always create (empty okay - 0 token cost, clear structure)

## 4. Create Structure

```bash
mkdir -p ai/research ai/design ai/decisions
```

**Templates:** See PRACTICES.md lines 277-291 (TODO), 293-314 (STATUS), 316-339 (DECISIONS), 341-353 (RESEARCH), 247-275 (PLAN if needed)

**File initialization:**

**ai/TODO.md:**
```markdown
## High Priority
- [ ] [Add tasks from detection: missing tests, TODO comments, etc.]

## In Progress
- [ ]

## Backlog
- [ ]

**Note:** Keep current work only. Delete completed immediately (no "Done" section).
```

**ai/STATUS.md:**
```markdown
## Current State
| Metric | Value | Updated |
|--------|-------|---------|
| [Detect if applicable: test coverage, build status] | | YYYY-MM-DD |

## What Worked
- Initial setup complete

## What Didn't Work
-

## Active Work
Initial AI context setup.

## Blockers
-

**Note:** Update EVERY session. Prune historical content (trust git history).
```

**ai/DECISIONS.md:** (Include PRACTICES.md template lines 316-339 as comment)

**ai/RESEARCH.md:** (Include PRACTICES.md template lines 341-353 as comment)

**ai/PLAN.md (if complex):** (Include PRACTICES.md template lines 247-275)

## 5. Create AGENTS.md

**Structure:** Tables/lists/code blocks (machine-readable). Comprehensive coverage. NO duplication with ai/ (use pointers).

**Include:**
- Project overview (detected description)
- Structure table (docs/, ai/, src/, tests/, etc.)
- AI context organization (session vs reference files - see template)
- Tech stack table (detected: language, framework, package manager, tools)
- Commands (detected: build/test/run or TBD)
- Code standards (detect from existing code or empty table)
- Claude Code integration (if .claude/ exists: commands, MCP, hooks)
- Current focus pointers (ai/STATUS.md, ai/PLAN.md if exists)

**Template:**

```markdown
# [DETECTED PROJECT NAME]

[DETECTED DESCRIPTION or TBD]

## Project Structure

| Directory | Purpose |
|-----------|---------|
| docs/ | User/team documentation |
| ai/ | **AI session context** - workspace for tracking state across sessions |
[DETECTED: src/, lib/, tests/, etc.]

### AI Context Organization

**Purpose:** AI maintains project context between sessions using ai/

**Session files** (read every session):
- ai/STATUS.md — Current state, metrics, blockers (read FIRST)
- ai/TODO.md — Active tasks only
- ai/DECISIONS.md — Architectural decisions
- ai/RESEARCH.md — Research index
[- ai/PLAN.md — Strategic roadmap (only if created)]

**Reference files** (loaded on demand):
- ai/research/ — Detailed research
- ai/design/ — Design specs
- ai/decisions/ — Archived decisions

**Token efficiency:** Session files = current work only. Details in subdirs.

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Language | [DETECTED] |
| Framework | [DETECTED or None] |
| Package Manager | [DETECTED] |
[DETECTED: database, testing, linting, etc.]

## Commands

```bash
# Build
[DETECTED or TBD]

# Test
[DETECTED or TBD]

# Run
[DETECTED or TBD]

# Lint
[DETECTED or TBD]
```

## Code Standards

[DETECT from existing code or provide empty table]

| Aspect | Standard |
|--------|----------|
[naming, formatting, imports, error handling if detected]

## Claude Code Integration

[Only if .claude/ exists]
| Feature | Details |
|---------|---------|
| Commands | [LIST from .claude/commands/] |
| MCP Servers | [FROM settings.json] |
| Hooks | [FROM settings.local.json or "None"] |

## Development Workflow

**Before implementing:**
1. Research best practices → ai/research/{topic}.md
2. Document decision → DECISIONS.md
3. Design if complex → ai/design/{component}.md
4. Implement → [src dir]
5. Update STATUS.md with learnings

## Current Focus

See ai/STATUS.md for current state[, ai/PLAN.md for roadmap]
```

**Create symlink:** `ln -s AGENTS.md CLAUDE.md`

## 6. Verify & Report

**Check (parallel):**
```bash
ls -la AGENTS.md CLAUDE.md
ls -la ai/
wc -l AGENTS.md ai/*.md
```

**Verification:**

| Check | Expected |
|-------|----------|
| Symlink | CLAUDE.md → AGENTS.md |
| AGENTS.md format | Tables/lists, clear ## sections |
| AGENTS.md content | Comprehensive, no ai/ duplication, explains ai/ purpose |
| ai/ files | STATUS.md, TODO.md, DECISIONS.md, RESEARCH.md (+ PLAN.md if complex) |
| ai/ subdirs | research/, design/, decisions/ exist |
| Claude Code | Documented if .claude/ exists |

**Output:**

```markdown
## AI Context Setup Complete

**Scenario:** [detected scenario from step 2]

**Project detected:**
- Name: [detected]
- Language: [detected]
- Framework: [detected]
- Build: [detected or TBD]
- Test: [detected or TBD]
- Complexity: [minimal/standard/complex]

**AGENTS.md:** [X] lines
- Symlink: CLAUDE.md → AGENTS.md ✓
- Format: Tables/lists ✓
- Claude Code: [commands/MCP/hooks or "none"]

**ai/ structure:**
- STATUS.md ✓
- TODO.md ✓
- DECISIONS.md ✓
- RESEARCH.md ✓
- PLAN.md: [✓ created / ⊘ skipped - why]
- Subdirs: research/, design/, decisions/ ✓

**Preview AGENTS.md** (first 50 lines):
[SHOW]

**Next:**
1. Update ai/STATUS.md with current project state
2. Add tasks to ai/TODO.md
3. Commit: `git add . && git commit -m "Initialize AI context"`
```

## Maintenance

**Version:** 2025-11 (review quarterly or when PRACTICES.md changes)
**Self-optimization:** Apply same token efficiency principles to this command
