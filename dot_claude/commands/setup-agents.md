Analyze this project and set up AI agent configuration files.

**Tasks:**

1. **Analyze the project:**
   - Verify we're in a git repository (check for .git/)
   - Examine languages, frameworks, and tools used
   - Check for existing AGENTS.md or CLAUDE.md files
   - Determine which sections from global ~/.claude/CLAUDE.md are relevant

2. **Handle existing files:**
   - **IF neither AGENTS.md nor CLAUDE.md exist:**
     - Create AGENTS.md from scratch
     - Create symlink: `ln -s AGENTS.md CLAUDE.md`

   - **IF only AGENTS.md exists:**
     - Update AGENTS.md with sections from global ~/.claude/CLAUDE.md
     - Add comment: "# Updated: [date]"
     - Create symlink: `ln -s AGENTS.md CLAUDE.md`

   - **IF only CLAUDE.md exists (and it's a file, not symlink):**
     - Rename CLAUDE.md → AGENTS.md
     - Merge with sections from global ~/.claude/CLAUDE.md
     - Create symlink: `ln -s AGENTS.md CLAUDE.md`

   - **IF both exist and CLAUDE.md is symlink to AGENTS.md:**
     - Update AGENTS.md (already properly configured)

   - **IF both exist and both are files:**
     - Merge both files into AGENTS.md (preserve all content from both)
     - Remove CLAUDE.md
     - Create symlink: `ln -s AGENTS.md CLAUDE.md`

   - **IF CLAUDE.md is symlink to somewhere else:**
     - Ask user what to do before modifying

3. **Content to include in AGENTS.md:**
   - Extract relevant sections from global ~/.claude/CLAUDE.md:
     - Critical Rules (always include)
     - Code Standards (always include)
     - Comments (always include)
     - Git Workflow (always include)
     - ASK on Blockers (always include)
     - Language-Specific sections (only if used in this project)
     - Pattern Library reference (only if external/agent-contexts/ exists or ~/github/nijaru/agent-contexts/ is accessible)
     - Performance Claims (if project involves performance/benchmarking work)
   - Adapt content to be project-specific where appropriate
   - Add header: "# AI Agent Instructions - Project: [name]"

4. **Verify setup:**
   - Check symlink points correctly
   - Verify AGENTS.md has all critical sections
   - Confirm no machine-specific paths (use ~/ not absolute paths)

**Output:**
- Show which scenario was detected (neither/only AGENTS.md/only CLAUDE.md/both exist)
- List what sections were included from global ~/.claude/CLAUDE.md and why
- Display first 30 lines of final AGENTS.md
- Confirm final state: AGENTS.md (file) + CLAUDE.md (symlink → AGENTS.md)
- Verify both files work with Claude Code, Sourcegraph Amp, and any tool using AGENTS.md
