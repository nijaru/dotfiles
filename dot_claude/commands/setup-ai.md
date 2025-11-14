Analyze project and set up AI agent configuration files.

**Philosophy:**
- AGENTS.md = primary file (tool-agnostic, works with all AI coding agents)
- CLAUDE.md → AGENTS.md = symlink (Claude Code compatibility)
- Reference: github.com/nijaru/agent-contexts PRACTICES.md
- Optimize AGENTS.md for AI consumption: tables, lists, clear sections, structured
- Quality over brevity: well-structured 500 lines > poorly organized 100 lines
- DO NOT duplicate global ~/.claude/CLAUDE.md or ai/ files
- NO time estimates in PLAN.md unless external deadline exists

**Reading order:** PLAN → STATUS → TODO → DECISIONS → RESEARCH

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

### 3. Determine PLAN.md

Check README/docs for: "phases", "milestones", "roadmap", "v1.0", "v2.0", "Q1", "Q2", quarters, multi-month timeline

- **If found** → create PLAN.md
- **If unclear** → ask: "Does this project have 3+ phases or critical dependencies?"
- **If no** → skip (can add later)

### 4. Create ai/ Directory

```bash
mkdir -p ai/research ai/design
```

**ai/TODO.md:**
```markdown
## High Priority
- [ ]

## In Progress
- [ ]

## Backlog
- [ ]
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
```

**ai/DECISIONS.md:**
```markdown
<!-- Template:

## YYYY-MM-DD: Decision Title

**Context**: [situation]
**Decision**: [choice]
**Rationale**:
- [reason 1]
- [reason 2]

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| | |

**Evidence**: [ai/research/ link]
**Commits**: [hash]

---
-->
```

**ai/RESEARCH.md:**
```markdown
<!-- Template:

## Topic (YYYY-MM-DD)
**Sources**: [links, books, docs]
**Key Finding**: [main takeaway]
**Decision**: [action]
→ Details: ai/research/topic.md

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
| ai/ | AI working context (read ai/STATUS.md first) |
[List detected dirs: src/, lib/, tests/, etc.]

### AI Context Files

| File | Purpose | Update Frequency |
|------|---------|------------------|
[- ai/PLAN.md | Dependencies, architecture, scope | Quarterly/pivots  # only if created]
| ai/STATUS.md | Current state, metrics, blockers | Every session (read FIRST) |
| ai/TODO.md | Active tasks | As tasks change |
| ai/DECISIONS.md | Architectural decisions | On decisions |
| ai/RESEARCH.md | Research index | During research |
| ai/research/ | Detailed research findings | As needed |
| ai/design/ | Design documents | As needed |

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
- [ ] Quality format: well-structured, easy to parse
- [ ] Documents Claude Code integration if .claude/ exists

**Check ai/ structure:**
- [ ] ai/STATUS.md populated with template
- [ ] ai/TODO.md populated with sections
- [ ] ai/DECISIONS.md has template
- [ ] ai/RESEARCH.md has template
- [ ] ai/PLAN.md created if 3+ phases (or skipped)
- [ ] ai/research/ directory exists
- [ ] ai/design/ directory exists

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
