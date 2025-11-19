Audit and maintain AI context files following best practices.

**Reference:** github.com/nijaru/agent-contexts PRACTICES.md
**Philosophy:** Session files = current/active only. Reference files = on-demand. Trust git history.

## Execution Guidelines

- Run analysis operations in parallel (file reads, checks)
- Use extended reasoning for large codebases (many ai/ files, complex structure)
- Ask before deleting files - show what will be consolidated
- Commit after each logical change (granular history)

## 1. Analyze Structure (Parallel)

| Check | Look For | Tool |
|-------|----------|------|
| Config | AGENTS.md exists, CLAUDE.md symlink correct | ls -la |
| ai/ files | STATUS.md, TODO.md, DECISIONS.md, RESEARCH.md, PLAN.md | ls ai/ |
| Subdirs | research/, design/, decisions/, tmp/ exist | ls ai/ |
| ai/tmp/.gitignore | Exists and contains '*' | cat ai/tmp/.gitignore |
| File sizes | Detect bloat (>500 lines session files) | wc -l ai/*.md |
| TODO.md file links | Tasks include file links [src/file.ts] | grep -c '\[.*\].*\[.*\]' ai/TODO.md |
| Claude Code | .claude/commands/, MCP servers, hooks documented in AGENTS.md | grep -l "Claude Code" AGENTS.md |

**Action:** Run all checks in parallel. Consolidate findings.

## 2. Identify Issues

**Time-tracking artifacts:**

| File | Anti-Pattern | Fix |
|------|-------------|-----|
| PLAN.md | "Week X Day Y", "~X days", "Q1 2025" (no external deadline) | Remove estimates, keep dependencies |
| ai/ root | WEEK*_DAY*.md files (artificial time tracking) | Consolidate → STATUS/DECISIONS → Delete |
| STATUS.md | Progress markers "← YOU ARE HERE", "_Last Updated: Week X_" | Remove markers |

**Token efficiency issues:**

| Issue | Impact | Fix |
|-------|--------|-----|
| Session files with historical content | Loads irrelevant context every session | Prune to current/active only |
| Detailed research in RESEARCH.md | Wastes tokens | Move details → ai/research/, keep index |
| Large DECISIONS.md | Hard to navigate, loads all every session | Split by topic or archive superseded |
| Design specs in ai/ root | Loads every session | Move → ai/design/ |
| Missing subdirs | No place for detailed content | Create research/, design/, decisions/, tmp/ |
| Missing ai/tmp/.gitignore | Temp files tracked in git | Create .gitignore with '*' |

**New pattern adoption:**

| Pattern | Check | Fix |
|---------|-------|-----|
| TODO.md file links | Tasks missing context links | Add file links: `- [ ] Fix bug [src/lib/cache.ts]` |
| ai/KNOWLEDGE.md | Codebase quirks with no home | Create ai/KNOWLEDGE.md for permanent quirks |
| ai/tmp/ gitignored | Temp files tracked | Create ai/tmp/.gitignore with '*' |

**AGENTS.md issues:**

| Issue | Fix |
|-------|-----|
| CLAUDE.md symlink missing or wrong | Create/fix: CLAUDE.md → AGENTS.md |
| Prose instead of tables | Convert to tables/lists |
| Duplicates ai/ content | Replace with pointers: "See ai/STATUS.md" |
| Missing Claude Code integration | Document .claude/commands/, MCP, hooks |
| No ai/ purpose explanation | Add "AI session context" description |

**Anti-patterns:**

| Pattern | Problem | Solution |
|---------|---------|----------|
| ai/archive/ | Don't archive - use git | Consolidate valuable info → delete dir |
| Code in ai/ | ai/ is for meta-work only | Move → src/ or delete |
| Duplicate docs/ and ai/ | Permanent vs working context confused | docs/ = permanent, ai/ = session |
| Human docs in ai/ | ai/ optimized for AI, not humans | Move → docs/ |

## 3. Present Findings

**Report format:**

```markdown
## AI Context Audit

**Time-tracking artifacts:**
- PLAN.md: [N] time estimates, [N] progress markers
- [N] WEEK*_DAY*.md files found

**Token efficiency:**
- Session files: [STATUS: X lines, TODO: Y lines, DECISIONS: Z lines, RESEARCH: W lines]
- Bloated (>500 lines): [list]
- Historical content in: [list]
- Detailed content in session files: [list] (should be in subdirs)
- Missing subdirs: [list]
- Missing ai/tmp/.gitignore: [yes/no]

**New patterns:**
- TODO.md file links: [N tasks with links / M total tasks]
- ai/KNOWLEDGE.md: [exists / needed / not needed]
- ai/tmp/: [exists with gitignore / missing / not gitignored]

**AGENTS.md:**
- Symlink: [correct / missing / wrong]
- Format: [N] prose sections need tables
- Duplication: [N] sections duplicate ai/
- Claude Code: [documented / missing]
- ai/ purpose: [explained / missing]

**Anti-patterns:**
[list if found]

**Files with real dates** (GOOD - keeping):
[list: ANALYSIS_2025-11-05.md, etc.]
```

If no issues: "✓ AI context follows best practices" and exit.

## 4. Get Approval

Ask: "Apply maintenance to ai/? This will prune historical content (git preserves all history)."

## 5. Fix Issues (Commit Each)

**Remove time-tracking artifacts:**

| Item | Action | Commit Message |
|------|--------|----------------|
| PLAN.md estimates | Remove time refs, keep dependencies | "Remove time estimates from PLAN.md" |
| WEEK*_DAY*.md | Read → consolidate info → delete | "Remove time-tracking files" |
| Progress markers | Delete from all files | "Remove progress markers" |

**Promote learnings (BEFORE pruning STATUS.md):**

| Learning Type | Destination | Example |
|---------------|-------------|---------|
| Permanent project rule | AGENTS.md (Standards section) | "Always use UTC timestamps", "Never expose internal IDs in API" |
| Permanent codebase quirk | ai/KNOWLEDGE.md or docs/internal/ | "Auth service has 30s cache", "DB migration order matters" |
| Transient/Fixed | Delete | "Build was failing due to npm cache (now fixed)" |

**Action:** Review STATUS.md "Recent Learnings" → Promote permanent knowledge → Then prune

**Prune session files:**

| File | Keep | Delete | Commit Message |
|------|------|--------|----------------|
| STATUS.md | Current metrics, active blockers, recent learnings (1-2 sessions) | Old pivots, completed phases, resolved blockers, historical metrics (AFTER promoting learnings) | "Prune STATUS.md - current state only" |
| TODO.md | Pending, in-progress | All completed tasks, "Done" sections | "Clean TODO.md - active work only" |
| DECISIONS.md | Active decisions affecting codebase | Superseded/reversed (→ decisions/superseded-YYYY-MM.md) | "Archive superseded decisions" |
| RESEARCH.md | Index with summaries | Detailed research (→ research/{topic}.md) | "Move detailed research to subdir" |
| PLAN.md | Current phase + next 1-2 | Completed phases | "Prune PLAN.md - current phases only" |

**Organize DECISIONS.md (if >50 decisions or hard to navigate):**
1. Superseded → ai/decisions/superseded-YYYY-MM.md
2. If still large: split by topic → ai/decisions/{architecture,database,etc}.md
3. Keep index in DECISIONS.md

**Move detailed content to subdirs:**

| Content | From | To | Benefit |
|---------|------|----|---------|
| Detailed research | RESEARCH.md | ai/research/{topic}.md | Only load when needed |
| Design specs | ai/ root | ai/design/{component}.md | Only load when needed |
| Superseded decisions | DECISIONS.md | ai/decisions/superseded-YYYY-MM.md | Cleaner main file |

**Ensure subdirs exist:**
```bash
mkdir -p ai/research ai/design ai/decisions ai/tmp
echo '*' > ai/tmp/.gitignore  # Ensure gitignore exists
```

**Adopt new patterns:**

| Pattern | Action | Commit Message |
|---------|--------|----------------|
| ai/tmp/.gitignore | Create if missing: `echo '*' > ai/tmp/.gitignore` | "Add ai/tmp/.gitignore" |
| TODO.md file links | Review tasks, add file links where helpful: `- [ ] Fix cache bug [src/lib/cache.ts]` | "Add file links to TODO.md" |
| ai/KNOWLEDGE.md | Create if codebase quirks exist (check STATUS.md learnings for candidates) | "Create ai/KNOWLEDGE.md for codebase quirks" |

**ai/KNOWLEDGE.md template (if creating):**
```markdown
# Codebase Knowledge

**Purpose:** Permanent quirks, gotchas, and non-obvious behavior

| Area | Knowledge | Why |
|------|-----------|-----|
| Auth | Session cache is 30s | Performance optimization, can cause delay in logout |
| Database | Migrations must run in order | Foreign key dependencies |
| [Area] | [Quirk/Gotcha] | [Rationale] |

**Note:** For temporary issues, use STATUS.md. For architecture decisions, use DECISIONS.md.
```

**Fix AGENTS.md (see PRACTICES.md lines 494-539):**

| Fix | Action |
|-----|--------|
| Symlink | Create CLAUDE.md → AGENTS.md if missing |
| Format | Convert prose → tables/lists |
| Duplication | Replace duplicated ai/ content with pointers |
| Structure | Add clear ## sections if missing |
| ai/ explanation | Add "AI session context" section if missing |
| ai/ new files | Document ai/KNOWLEDGE.md and ai/tmp/ if they exist |
| Claude Code | Document .claude/commands/, MCP servers, hooks |
| Comprehensiveness | Add missing: commands, standards, structure |

**Template for ai/ explanation in AGENTS.md:**
```markdown
### AI Context Organization

**Purpose:** AI maintains project context between sessions using ai/

**Session files** (read every session):
- ai/STATUS.md — Current state, metrics, blockers (read FIRST)
- ai/TODO.md — Active tasks only
- ai/DECISIONS.md — Architectural decisions
- ai/RESEARCH.md — Research index

**Reference files** (loaded on demand):
- ai/research/ — Detailed research
- ai/design/ — Design specs
- ai/decisions/ — Archived decisions
- ai/tmp/ — Temporary artifacts (gitignored)

**Token efficiency:** Session files = current work only. Details in subdirs.
```

**Remove anti-patterns:**

| Pattern | Action |
|---------|--------|
| ai/archive/ | Review → consolidate → delete directory |
| Code in ai/ | Ask: "Move to src/ or delete?" → execute |
| Duplicate docs | Keep permanent → docs/, working context → ai/ |

## 6. Verify (Parallel)

```bash
ls -la AGENTS.md CLAUDE.md
ls -la ai/
wc -l ai/*.md
```

| Check | Expected |
|-------|----------|
| Symlink | CLAUDE.md → AGENTS.md |
| AGENTS.md | Tables/lists, clear sections, no duplication, explains ai/ |
| Session files | <500 lines each, current/active only |
| Subdirs | research/, design/, decisions/, tmp/ exist (tmp/ gitignored) |
| No time-tracking | No WEEK*.md, no estimates (unless external deadline) |
| Claude Code | Documented if .claude/ exists |

## 7. Report

```markdown
## AI Context Maintenance Complete

**Changes applied:**

**Time-tracking:**
- Removed [N] time estimates from PLAN.md
- Deleted [N] WEEK*_DAY*.md files (info consolidated)
- Removed progress markers

**Token efficiency:**
- STATUS.md: [before] → [after] lines (pruned historical content)
- TODO.md: Removed [N] completed tasks
- DECISIONS.md: [action taken: archived superseded / split by topic]
- RESEARCH.md: [moved N topics to ai/research/ / kept as-is]
- PLAN.md: Pruned to current + next phases
- Created subdirs: research/ ([N] files), design/ ([N] files), decisions/ ([N] files), tmp/ (gitignored)

**New patterns adopted:**
- ai/tmp/.gitignore: [created / already exists]
- TODO.md file links: Added to [N] tasks
- ai/KNOWLEDGE.md: [created with N quirks / not needed / already exists]

**AGENTS.md:**
- Symlink: CLAUDE.md → AGENTS.md ✓
- Format: Converted [N] prose sections to tables
- Removed [N] duplicated sections
- Added ai/ purpose explanation
- Claude Code: [documented commands/MCP/hooks]

**Anti-patterns fixed:**
[list if any]

**Result:**
- Session files focused on current/active work
- Detailed content in subdirs (loaded only when needed)
- Token-efficient structure (load only what's relevant per session)

**Note:** All historical content preserved in git history
```

## Development Workflow (Add to AGENTS.md if missing)

```markdown
## Development Workflow

**Before implementing:**
1. Research best practices → ai/research/{topic}.md
2. Document decision → DECISIONS.md
3. Design if complex → ai/design/{component}.md
4. Implement → [src dir]
5. Update STATUS.md with learnings

**Multi-session handoff:**
- Update STATUS.md: current state, next steps, blockers
- Mark TODO.md clearly: pending, in-progress, blocked
- Link context: "See ai/research/auth-eval.md"
```

## Maintenance

**Version:** 2025-11 (review quarterly or when PRACTICES.md changes)
**Self-optimization:** Apply same token efficiency principles to this command
