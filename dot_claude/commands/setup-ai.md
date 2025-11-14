Analyze project and set up AI agent configuration files.

**Philosophy:**
- AGENTS.md = primary file (tool-agnostic, works with all AI coding agents)
- CLAUDE.md → AGENTS.md = symlink (Claude Code compatibility)
- Reference: github.com/nijaru/agent-contexts PRACTICES.md
- Optimize AGENTS.md for AI consumption: tables, lists, clear sections, structured
- Quality over brevity: well-structured 500 lines > poorly organized 100 lines
- DO NOT duplicate global ~/.claude/CLAUDE.md or ai/ files
- NO time estimates in PLAN.md unless external deadline exists

**ai/ directory purpose:**
- **AI session context management** - AI agent's workspace for tracking project state between sessions
- **Session files** (ai/ root): Read every session - keep current/active work only
- **Reference files** (subdirs): Read only when needed - no token cost unless accessed
- **Not for humans** - User documentation goes in docs/, AI working context in ai/
- **Token efficiency** - Subdirectories prevent loading unused context every session
- **Scales with project** - Start minimal (STATUS.md + TODO.md), grow as needed
- **Prune based on relevance** - Delete historical/completed content, not based on size

**Reading order:** PLAN → STATUS → TODO → DECISIONS → RESEARCH
(Load subdirectories only when context requires: research/, design/, decisions/)

**Claude Code best practices:**
- Project uses AGENTS.md/CLAUDE.md (this file)
- Global config in ~/.claude/CLAUDE.md (workflow rules, stack preferences)
- Custom slash commands in .claude/commands/ (optional)
- MCP servers in ~/.claude/settings.json (optional)
- Hooks in project settings.local.json (optional)

**AI coding agent best practices:**
- Research current best practices, don't rely on stale patterns
- Update STATUS.md every session (current state + learnings)
- Trust git history - delete completed/historical content
- Use tables/lists over prose for efficient token usage
- Separate permanent docs (docs/) from working context (ai/)
- Focus PLAN.md on dependencies ("A before B"), not time estimates
- Keep TODO.md current only (no "Done" sections)
- Archive superseded decisions to ai/decisions/superseded-YYYY-MM.md
- Quality over brevity in AGENTS.md (comprehensive > minimal)

## Tasks

**Goal:** Set up AI agent context management for this project

AI will use ai/ directory to:
- Track project state across sessions (STATUS.md)
- Manage active work (TODO.md)
- Record architectural decisions (DECISIONS.md)
- Index research findings (RESEARCH.md, research/)
- Document designs before implementation (design/)
- Plan multi-phase work (PLAN.md - optional)

**Principle:** Start minimal, scale complexity with project size

### 1. Analyze Project

Detect and gather:
- Git repo (check .git/)
- Project name (git remote, package.json, Cargo.toml, pyproject.toml)
- Languages/frameworks (file extensions, package managers, config files)
- Build/test/run commands (package.json scripts, Makefile, Cargo.toml)
- Project description (README first paragraph)
- Phases/milestones/roadmap (README, docs/)
- Existing CLAUDE.md or AGENTS.md

**CRITICAL**: Fill in ALL detected info. Use [TBD] ONLY when cannot detect.

### 2. Handle Existing Files

| Scenario | Action |
|----------|--------|
| Neither exists | Create AGENTS.md + symlink CLAUDE.md → AGENTS.md |
| Only AGENTS.md (file) | Keep as-is + create symlink CLAUDE.md → AGENTS.md |
| Only CLAUDE.md | Rename to AGENTS.md + create symlink CLAUDE.md → AGENTS.md |
| Both, CLAUDE.md → AGENTS.md | Already correct, update content if needed |
| Both files | Merge into AGENTS.md + remove CLAUDE.md + create symlink CLAUDE.md → AGENTS.md |
| CLAUDE.md → elsewhere | Ask user before modifying |

### 3. Determine PLAN.md and Directory Structure

**Check project complexity indicators:**
- README/docs mentions: "phases", "milestones", "roadmap", "v1.0", "v2.0", quarters
- Multi-phase development
- Critical dependencies between components
- External deadlines

**Determine structure:**

| Project Size | Duration | Files to Create | Subdirs |
|--------------|----------|-----------------|---------|
| **Minimal** | <1 month | STATUS.md, TODO.md | When needed (3+ files) |
| **Standard** | 1-6 months | +DECISIONS.md, RESEARCH.md | When needed (3+ files) |
| **Complex** | 6+ months | +PLAN.md | research/, design/ as needed |

**Questions to ask:**
- **If found indicators** → create PLAN.md
- **If unclear** → ask: "Does this project have 3+ phases or critical dependencies?"
- **If no indicators** → skip PLAN.md (can add later)
- **Subdirectories** → create research/ and design/ dirs, populate as needed

### 4. Create ai/ Directory Structure

**Philosophy:** Start minimal, add complexity as project grows

```bash
mkdir -p ai/research ai/design ai/decisions
```

**Always create subdirectories** (even if empty initially):
- ai/research/ - Detailed research findings (loaded on demand)
- ai/design/ - Design specifications (loaded on demand)
- ai/decisions/ - Decision organization (used when DECISIONS.md >50 entries)

**Why create empty dirs:**
- Clear structure for AI to use
- No token cost (empty dirs don't consume tokens)
- Ready when needed (AI knows where to put detailed content)

**Token efficiency:**
- Session files (ai/*.md): ~1-2K tokens per session
- Reference files (ai/*/): 0 tokens unless AI explicitly loads them

**ai/TODO.md:**
```markdown
## High Priority
- [ ]

## In Progress
- [ ]

## Backlog
- [ ]

**Note:** Keep current work only. Delete completed tasks immediately (no "Done" section).
```

**ai/STATUS.md:**
```markdown
## Current State
| Metric | Value | Updated |
|--------|-------|---------|
| | | [TODAY'S DATE] |

## What Worked
-

## What Didn't Work
-

## Active Work
Initial setup complete.

## Blockers
-

**Note:** Update this file EVERY session with current state, learnings, and progress.
Prune historical/completed content regularly (trust git history).
```

**ai/DECISIONS.md:**
```markdown
<!-- AI Decision Log

This file tracks architectural decisions for AI context across sessions.
When becomes difficult to navigate: split to ai/decisions/{topic}.md
When decisions superseded: move to ai/decisions/superseded-YYYY-MM.md

Template:

## YYYY-MM-DD: Decision Title

**Context**: [situation requiring decision]
**Decision**: [choice made]
**Rationale**:
- [reason 1]
- [reason 2]

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| | |

**Evidence**: [link to ai/research/ if applicable]
**Commits**: [hash]

---
-->
```

**ai/RESEARCH.md:**
```markdown
<!-- Research Index

This file indexes research findings for AI context.
Detailed research goes in ai/research/{topic}.md
Keep this file as index only (summaries + pointers).

Template:

## Topic (YYYY-MM-DD)
**Sources**: [links, books, docs]
**Key Finding**: [main takeaway]
**Decision**: [action taken or pending]
→ Details: ai/research/topic.md  # if detailed research exists

## Open Questions
- [ ] Question needing research
-->
```

**ai/PLAN.md** (only if determined needed):
```markdown
## Goal
[What building? Why? External deadline if exists]

## Phases
| Phase | Status | Deliverables | Success Criteria |
|-------|--------|--------------|------------------|
| Phase 1 | ← CURRENT | | |
| Phase 2 | Planned | | |

## Dependencies
| Must Complete | Before Starting | Why |
|---------------|-----------------|-----|
| | | |

## Technical Architecture
| Component | Approach | Rationale |
|-----------|----------|-----------|
| | | |

## Out of Scope
- [deferred features]

**Note**: Skip time estimates (days/weeks/quarters) unless external deadline exists. Focus: what blocks what.
```

### 5. Create AGENTS.md

**CRITICAL: Follow PRACTICES.md optimization (lines 273-295)**

Use machine-readable structure:
- Tables, lists, code blocks (NOT prose)
- Clear ## sections with logical hierarchy
- Comprehensive coverage (all commands, standards, structure)
- NO duplication with ai/ files (use pointers)

**What to include:**
- ✅ Project overview, description
- ✅ Technology stack (detected languages, frameworks, tools)
- ✅ Build/test/deploy commands
- ✅ Code standards, naming conventions
- ✅ Development workflow
- ✅ Project structure explanation
- ✅ Pointers to ai/ files: "See ai/STATUS.md for current state"
- ✅ Claude Code integration (.claude/commands/, MCP servers, hooks if exist)

**What NOT to include:**
- ❌ Current issues/blockers (→ ai/STATUS.md)
- ❌ Active tasks/TODOs (→ ai/TODO.md)
- ❌ Recent learnings/metrics (→ ai/STATUS.md)
- ❌ Detailed roadmap (→ ai/PLAN.md)
- ❌ Duplicating ai/ file content

**Template using ALL detected information:**

```markdown
# [DETECTED PROJECT NAME]

[Description from README or "TBD"]

## Project Structure

| Directory | Purpose |
|-----------|---------|
| docs/ | Permanent user/team documentation |
| ai/ | **AI session context** - Agent workspace for tracking state across sessions |
[List detected dirs: src/, lib/, tests/, etc.]

### AI Context Organization

**Purpose:** AI uses ai/ to maintain project context between sessions

**Session files** (ai/ root - read every session):

| File | Purpose | Read Frequency |
|------|---------|----------------|
| ai/STATUS.md | Current state, metrics, blockers | Every session (read FIRST) |
| ai/TODO.md | Active tasks only | Every session |
| ai/DECISIONS.md | Active architectural decisions | Every session |
| ai/RESEARCH.md | Research findings index | As needed |
[- ai/PLAN.md | Strategic roadmap, dependencies | Major pivots  # only if created]

**Reference files** (subdirectories - loaded only when needed):

| Directory | Purpose | When to Use |
|-----------|---------|-------------|
| ai/research/ | Detailed research findings | On demand |
| ai/design/ | Design specifications, architecture docs | On demand |
| ai/decisions/ | Superseded decisions, topic-based splits | When DECISIONS.md difficult to navigate |

**Token efficiency:** Session files kept current/active only. Detailed content in subdirectories loaded only when AI needs them.

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Language | [DETECTED - "Python 3.11", "TypeScript", "Rust"] |
| Framework | [DETECTED - "Next.js", "FastAPI", "Axum", or "None"] |
| Package Manager | [DETECTED - "uv", "bun", "cargo"] |
[Other tools: database, testing, etc.]

## Development Commands

```bash
# Build
[DETECTED or "TBD"]

# Test
[DETECTED or "TBD"]

# Run
[DETECTED or "TBD"]
```

## Code Standards

[Empty table unless patterns detected in codebase]

| Aspect | Standard |
|--------|----------|
[Detected patterns like naming, formatting, imports, etc.]

## Claude Code Integration

[Only if .claude/ directory exists:]
| Feature | Status |
|---------|--------|
| Custom Commands | .claude/commands/[list detected] |
| MCP Servers | [check settings.json] |
| Project Hooks | [check settings.local.json] |

## Current Focus

**Current state:** ai/STATUS.md (read first)
[Only if PLAN.md: **Roadmap:** ai/PLAN.md]
```

### 6. Verify

**File structure:**
```bash
ls -la AGENTS.md CLAUDE.md
ls -la ai/
```

**Check AGENTS.md optimization:**
- [ ] CLAUDE.md → AGENTS.md symlink correct
- [ ] Uses tables, lists, code blocks (not prose)
- [ ] Clear ## sections with logical hierarchy
- [ ] Comprehensive coverage (tech stack, commands, standards)
- [ ] NO duplication with ai/ files (uses pointers)
- [ ] **Explains ai/ is for AI session context management**
- [ ] Quality format: well-structured, easy to parse
- [ ] Documents Claude Code integration if .claude/ exists

**Check ai/ structure:**
- [ ] ai/STATUS.md populated with template and notes
- [ ] ai/TODO.md populated with sections and notes
- [ ] ai/DECISIONS.md has template with usage guidance
- [ ] ai/RESEARCH.md has template with usage guidance
- [ ] ai/PLAN.md created if 3+ phases (or skipped)
- [ ] ai/research/ directory exists (even if empty)
- [ ] ai/design/ directory exists (even if empty)
- [ ] ai/decisions/ directory exists (even if empty)

## Output

Show structured report:
```markdown
## Setup Complete

**Scenario:** [detected scenario from step 2]

**AGENTS.md created:**
- Symlink: CLAUDE.md → AGENTS.md ✓
- Format: Tables/lists, clear sections ✓
- Detected: [project name], [language], [framework], [package manager]
- Commands: [build/test/run detected or TBD]
- Standards: [detected patterns or empty]
- Size: [X] lines
- Claude Code: [.claude/commands/, MCP servers, hooks - or "none"]

**ai/ directory:**
| File | Status |
|------|--------|
| STATUS.md | ✓ Template |
| TODO.md | ✓ Template |
| DECISIONS.md | ✓ Template |
| RESEARCH.md | ✓ Template |
| PLAN.md | [✓ Created / ⊘ Skipped - reason] |
| research/ | ✓ Directory |
| design/ | ✓ Directory |

**First 50 lines of AGENTS.md:**
[show preview]

**Next steps:**
1. Update ai/STATUS.md with current project state
2. Add active tasks to ai/TODO.md
3. Update AGENTS.md with project-specific details
4. Commit: `git add . && git commit -m "Initialize AI agent context"`
```
