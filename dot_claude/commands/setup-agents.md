Analyze this project and set up AI agent configuration files.

**Tasks:**

1. **Analyze the project:**
   - Examine languages, frameworks, and tools used
   - Check for existing AGENTS.md or CLAUDE.md files
   - Determine which sections from global ~/.claude/CLAUDE.md are relevant

2. **Create/update ./AGENTS.md:**
   - Extract relevant sections from ~/.claude/CLAUDE.md:
     - Critical Rules (always include)
     - Code Standards (always include)
     - Comments (always include)
     - Git Workflow (always include)
     - ASK on Blockers (always include)
     - Language-Specific sections (only if used in this project)
     - Pattern Library reference (if using agent-contexts)
     - Performance Claims (if project involves performance work)
   - Adapt content to be project-specific where appropriate
   - If AGENTS.md exists, preserve project-specific content and merge intelligently
   - Add header: "# AI Agent Instructions - Project: [name]"

3. **Create ./CLAUDE.md symlink:**
   - Create `ln -s AGENTS.md CLAUDE.md` in project root
   - Ensures both filenames work with different agents

4. **Verify setup:**
   - Check symlink points correctly
   - Verify AGENTS.md has all critical sections
   - Confirm no machine-specific paths (use ~/ not absolute paths)

**Output:**
- Show what sections were included and why
- Display first 30 lines of created AGENTS.md
- Confirm symlink created successfully
