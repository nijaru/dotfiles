Analyze project and set up AI agent configuration files.

**Philosophy:**
- AGENTS.md = primary file (tool-agnostic)
- CLAUDE.md → AGENTS.md = symlink (Claude Code compatibility)
- Reference: github.com/nijaru/agent-contexts
- Optimize AGENTS.md for AI consumption: tables, lists, clear sections, scannable
- DO NOT duplicate global ~/.claude/CLAUDE.md or ai/ files

**Reading order:** PLAN → STATUS → TODO → DECISIONS → RESEARCH

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
mkdir -p ai/research
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
[What building? Target timeline?]

## Milestones
| Phase | Timeline | Status | Deliverables | Success Criteria |
|-------|----------|--------|--------------|------------------|
| Phase 1 | Q1 2025 | ← CURRENT | | |
| Phase 2 | Q2 2025 | Planned | | |

## Critical Dependencies
| Dependency | Blocks | Reason |
|------------|--------|--------|
| | | |

## Out of Scope
- [deferred features]
```

### 5. Create AGENTS.md

Use ALL detected information:

```markdown
# [DETECTED PROJECT NAME]

[Description from README or "TBD"]

## Project Structure
- Documentation: docs/
- AI working context: ai/
  [- PLAN.md — Strategic roadmap  # only if created]
  - STATUS.md — Current state (read first)
  - TODO.md — Next steps
[List detected dirs: src/, lib/, tests/, etc.]

## Technology Stack
- Language: [DETECTED - "Python 3.11", "TypeScript", "Rust"]
- Framework: [DETECTED - "Next.js", "FastAPI", "Axum", or "None"]
- Package Manager: [DETECTED - "uv", "bun", "cargo"]
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
[Empty unless patterns detected]

## Current Focus
See ai/STATUS.md for current state.
[Only if PLAN.md: For roadmap: ai/PLAN.md]
```

### 6. Verify

- Symlink correct: `ls -la AGENTS.md CLAUDE.md` (CLAUDE.md → AGENTS.md)
- AGENTS.md is well-structured (clear sections, no duplication)
- ai/ directory exists with populated files

## Output

Show:
- Which scenario detected
- ai/ directory created with populated files
- PLAN.md decision (created/skipped + why)
- First 50 lines of AGENTS.md
- Final state: AGENTS.md (file) + CLAUDE.md (symlink → AGENTS.md)
- List ai/ files with detected info summary
