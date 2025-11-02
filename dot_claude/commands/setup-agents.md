Analyze this project and set up AI agent configuration files.

**Philosophy:**
- CLAUDE.md = primary file (you use Claude Code)
- AGENTS.md → CLAUDE.md = symlink (compatibility with other tools)
- Reference: github.com/nijaru/agent-contexts for complete guide
- Keep project CLAUDE.md minimal (~100-200 lines)
- DO NOT duplicate from global ~/.claude/CLAUDE.md

**Reading order:**
STATUS.md (where am I?) → TODO.md (what's next?) → PLAN.md (strategic context) → DECISIONS.md (rationale) → RESEARCH.md (domain knowledge)

**Tasks:**

1. **Analyze the project:**
   - Verify we're in a git repository (check for .git/)
   - Examine languages, frameworks, and tools used
   - Check for existing CLAUDE.md or AGENTS.md files

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
     - Already properly configured, just update CLAUDE.md content

   - **IF both exist and both are files:**
     - Merge both files into CLAUDE.md (preserve all content)
     - Remove AGENTS.md
     - Create symlink: `ln -s CLAUDE.md AGENTS.md`

   - **IF AGENTS.md is symlink to somewhere else:**
     - Ask user what to do before modifying

3. **Create ai/ directory structure:**
   ```bash
   mkdir -p ai/research
   touch ai/TODO.md ai/STATUS.md ai/DECISIONS.md ai/RESEARCH.md
   # Only create PLAN.md if project has 3+ phases or critical dependencies
   # touch ai/PLAN.md  # Uncomment if needed
   ```

4. **Content for CLAUDE.md (minimal, ~100-200 lines):**
   ```markdown
   # Project: [name]

   [Brief 1-2 sentence description]

   ## Project Structure
   - Documentation: docs/
   - AI working context: ai/
     - STATUS.md — Current state (read first)
     - TODO.md — Next steps
     - PLAN.md — Strategic roadmap (optional, if 3+ phases/dependencies)
   [Other project-specific directories]

   ## Technology Stack
   - Language: [detected language]
   - Framework: [detected framework]
   [Other relevant tools]

   ## Development Commands
   ```bash
   # Build
   [detected build command]

   # Test
   [detected test command]

   # Run
   [detected run command]
   ```

   ## Code Standards
   [Project-specific patterns/conventions if any]

   ## Current Focus
   See ai/STATUS.md for current state and active work.
   For strategic roadmap: ai/PLAN.md (if complex project).
   ```

   **DO NOT duplicate from global ~/.claude/CLAUDE.md** - it's auto-loaded by Claude Code

5. **Initialize ai/ files with templates:**
   - ai/TODO.md: Empty checklist template (High Priority, In Progress, Backlog)
   - ai/STATUS.md: Basic structure (Current State, What Worked, What Didn't Work, Active Work, Blockers)
   - ai/DECISIONS.md: Empty with template comment
   - ai/RESEARCH.md: Empty with template comment
   - ai/PLAN.md: Only create if project has 3+ phases or critical dependencies (Goal, Milestones, Critical Dependencies, Out of Scope)

6. **Verify setup:**
   - Check symlink points correctly: `AGENTS.md → CLAUDE.md`
   - Verify CLAUDE.md is concise (<200 lines)
   - Confirm ai/ directory exists with all files
   - Test symlink works: `ls -la AGENTS.md CLAUDE.md`

**Output:**
- Show which scenario was detected
- Confirm ai/ directory created with files
- Display first 50 lines of final CLAUDE.md
- Confirm final state: CLAUDE.md (file) + AGENTS.md (symlink → CLAUDE.md)
- List created ai/ files
