Analyze this project and set up AI agent configuration files.

**Philosophy:**
- CLAUDE.md = primary file (you use Claude Code)
- AGENTS.md → CLAUDE.md = symlink (compatibility with other tools)
- Reference: github.com/nijaru/agent-contexts for complete guide
- Keep project CLAUDE.md minimal (~100-200 lines)
- DO NOT duplicate from global ~/.claude/CLAUDE.md

**Reading order:**
PLAN.md (strategic vision) → STATUS.md (current state) → TODO.md (next actions) → DECISIONS.md (rationale) → RESEARCH.md (domain knowledge)

**Tasks:**

1. **Analyze the project:**
   - Verify we're in a git repository (check for .git/)
   - Examine languages, frameworks, and tools used
   - Check for existing CLAUDE.md or AGENTS.md files
   - Check README/docs for mentions of phases, milestones, roadmap, or multi-month timeline

2. **Handle existing files:**
   - **IF neither CLAUDE.md nor AGENTS.md exist:**
     - Create CLAUDE.md from scratch
     - Create symlink: `ln -s CLAUDE.md AGENTS.md`

   - **IF only CLAUDE.md exists (and it's a file, not symlink):**
     - Keep CLAUDE.md as-is (already correct setup)
     - Create symlink: `ln -s CLAUDE.md AGENTS.md`

   - **IF only AGENTS.md exists:**
     - Rename AGENTS.md → CLAUDE.md
     - Create symlink: `ln -s CLAUDE.md AGENTS.md`

   - **IF both exist and AGENTS.md is symlink to CLAUDE.md:**
     - Already properly configured, just update CLAUDE.md content if needed

   - **IF both exist and both are files:**
     - Merge both files into CLAUDE.md (preserve all content)
     - Remove AGENTS.md
     - Create symlink: `ln -s CLAUDE.md AGENTS.md`

   - **IF AGENTS.md is symlink to somewhere else:**
     - Ask user what to do before modifying

3. **Determine if PLAN.md is needed:**
   - Check if README/docs mention: phases, milestones, roadmap, v1.0/v2.0, quarters, or multi-month timeline
   - If mentions found → suggest creating PLAN.md
   - If unclear → ask user: "Does this project have 3+ phases or critical dependencies between features?"
   - If yes → create PLAN.md with template
   - If no → skip PLAN.md (can add later if needed)

4. **Create ai/ directory and populate with templates:**

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
   | | | [date] |

   ## What Worked
   -

   ## What Didn't Work
   -

   ## Active Work


   ## Blockers
   -
   ```

   **ai/DECISIONS.md:**
   ```markdown
   <!-- Template for recording architectural decisions:

   ## YYYY-MM-DD: Decision Title

   **Context**: [What's the situation requiring a decision?]
   **Decision**: [What did we choose?]
   **Rationale**:
   - [Reason 1]
   - [Reason 2]

   **Tradeoffs**:
   | Pro | Con |
   |-----|-----|
   | | |

   **Evidence**: [Link to ai/research/ file if applicable]
   **Commits**: [commit hash]

   ---
   -->
   ```

   **ai/RESEARCH.md:**
   ```markdown
   <!-- Index of research findings:

   ## Topic Name (YYYY-MM-DD)
   **Sources**: [links, books, docs]
   **Key Finding**: [main takeaway]
   **Decision**: [action taken based on research]
   → Details: ai/research/topic-name.md

   ## Open Questions
   - [ ] Question needing research
   -->
   ```

   **ai/PLAN.md** (only if needed):
   ```markdown
   ## Goal
   [What are we building? Target timeline?]

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
   - [Feature deferred]
   ```

5. **Create CLAUDE.md (minimal, ~100-200 lines):**
   ```markdown
   # [Project Name]

   [Brief 1-2 sentence description]

   ## Project Structure
   - Documentation: docs/
   - AI working context: ai/
     - PLAN.md — Strategic roadmap [if created]
     - STATUS.md — Current state (read first)
     - TODO.md — Next steps
   [Other project-specific directories]

   ## Technology Stack
   - Language: [detected language]
   - Framework: [detected framework]
   [Other relevant tools]

   ## Development Commands
   ```bash
   # Build
   [detected build command or "TBD"]

   # Test
   [detected test command or "TBD"]

   # Run
   [detected run command or "TBD"]
   ```

   ## Code Standards
   [Project-specific patterns/conventions - leave empty if none detected]

   ## Current Focus
   See ai/STATUS.md for current state and active work.
   [If PLAN.md created: For strategic roadmap: ai/PLAN.md]
   ```

   **DO NOT duplicate from global ~/.claude/CLAUDE.md** - it's auto-loaded by Claude Code

6. **Verify setup:**
   - Check symlink points correctly: `AGENTS.md → CLAUDE.md`
   - Verify CLAUDE.md is concise (<200 lines)
   - Confirm ai/ directory exists with all required files
   - Test symlink: `ls -la AGENTS.md CLAUDE.md`

**Output:**
- Show which scenario was detected
- Confirm ai/ directory created with populated files
- Show if PLAN.md was created and why (or why not)
- Display first 50 lines of final CLAUDE.md
- Confirm final state: CLAUDE.md (file) + AGENTS.md (symlink → CLAUDE.md)
- List all created ai/ files with "(populated)" indicator
