Audit and maintain AI agent context files following current best practices.

**Purpose**: Audit and maintain AI agent context files. Apply best practices to ai/ directory - the AI agent's workspace for maintaining project state across sessions.

**Goals:**
- Remove time-tracking artifacts (agents use git, not calendars)
- Prune historical content from session files (trust git history)
- Organize reference files in subdirectories
- Optimize token efficiency (session files = current/active only, details in subdirs)
- Keep files current and focused on active work

**ai/ is for AI session context:**
- **Session files** (root): Read every session - keep current/active work only
- **Reference files** (subdirs): Read only when needed - can be any size
- Move detailed content to subdirectories to minimize tokens per session
- **Prune based on relevance** - Delete historical/completed content, not based on size

**Reference**: github.com/nijaru/agent-contexts PRACTICES.md

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
- AGENTS.md = primary file, CLAUDE.md → AGENTS.md symlink

**Claude Code integration:**
- Check .claude/commands/ for custom slash commands
- Document MCP servers if configured
- Note project-specific hooks if used

## Analysis Phase

### 1. Check Structure

Verify:
- ai/ directory exists with core files (STATUS.md, TODO.md, DECISIONS.md, RESEARCH.md)
- PLAN.md exists if needed (3+ phases/dependencies)
- AGENTS.md exists (or CLAUDE.md)
- ai/research/ directory for detailed research (optional)
- ai/design/ directory for design documents (optional)

### 2. Identify Issues

**Time-tracking artifacts:**
- PLAN.md: "Week X Day Y", "~X-Y days", quarter timelines without external deadline
- Artificial time tracking files: WEEK*_DAY*.md (no real date)
- Progress markers: "← YOU ARE HERE", "_Last Updated: Week X Day Y_"

**File maintenance needed:**
- STATUS.md: Contains substantial old pivots/completed phases/resolved blockers
- DECISIONS.md: Has many superseded/reversed decisions or is difficult to navigate
- TODO.md: Has "Done" sections or completed tasks
- PLAN.md: Completed phases, detailed task breakdowns (should be in TODO.md)

**Token efficiency issues:**
- Session files accumulating historical/detailed content
- Detailed research in RESEARCH.md (should be in ai/research/)
- DECISIONS.md difficult to navigate (split to ai/decisions/)
- Design specs in root (should be in ai/design/)
- Missing subdirectories (research/, design/, decisions/)

**AGENTS.md optimization needed:**
- Missing CLAUDE.md symlink or symlink points elsewhere
- Uses prose instead of tables/lists
- Lacks clear ## sections or poor hierarchy
- Duplicates ai/ file content instead of using pointers
- Missing comprehensive coverage (commands, standards, structure)
- Not documenting Claude Code integration (.claude/commands/, MCP, hooks)
- Doesn't explain ai/ is for AI session context management

**Anti-patterns:**
- ai/archive/ directory exists (use git instead)
- Code files in ai/ (belongs in src/)
- Duplicate content between docs/ and ai/
- Human documentation in ai/ (belongs in docs/)

### 3. Present Findings

Show structured report:
```markdown
## ai/ Directory Audit

**Time-tracking artifacts:**
- [ ] PLAN.md: [X] time estimates, [Y] progress markers
- [ ] [N] artificial time tracking files (WEEK*_DAY*.md)

**File maintenance:**
- [ ] STATUS.md: [size/tokens] - contains [N] old pivots/completed phases
- [ ] DECISIONS.md: [count] decisions - [N] superseded, [M] should split by topic
- [ ] TODO.md: [N] completed tasks in "Done" section
- [ ] PLAN.md: [N] completed phases

**Token efficiency:**
- [ ] Session files contain historical/completed content: [list if any]
- [ ] Detailed content in session files: [list if any - should be in subdirs]
- [ ] Detailed research in RESEARCH.md: [Y/N] (should be in ai/research/)
- [ ] Subdirectories exist: research/ [Y/N], design/ [Y/N], decisions/ [Y/N]
- [ ] Session files focused on current/active work only: [Y/N]

**AGENTS.md optimization:**
- [ ] Symlink: CLAUDE.md → AGENTS.md [correct / missing / wrong target]
- [ ] Format: [N] prose sections need conversion to tables/lists
- [ ] Duplication: [N] sections duplicate ai/ content
- [ ] Structure: [missing sections / poor hierarchy / good]
- [ ] Coverage: [missing: commands/standards/structure]
- [ ] AI context explanation: [missing / present]
- [ ] Claude Code: [.claude/ integration not documented]

**Anti-patterns:**
- [ ] ai/archive/ exists
- [ ] Code files in ai/
- [ ] Duplicate docs/ and ai/ content
- [ ] Human docs in ai/ (should be in docs/)

**Files with real dates (GOOD - keeping):**
- ai/research/ANALYSIS_2025-11-05.md
- ai/BENCHMARK_NOV2025.md
```

If no issues: "✓ ai/ directory and AGENTS.md follow best practices" and exit.

### 4. Get Approval

Ask: "Apply file maintenance to ai/ directory? This will prune historical content (git preserves all history)."

## Cleanup Phase

### 5. Remove Time-Tracking Artifacts

**PLAN.md:**
- Remove: "Week X Day Y", "~X-Y days/weeks", quarter timelines (unless external deadline), progress markers
- Keep: Dependencies, architecture, scope, success criteria
- Move detailed task breakdowns → TODO.md

**Artificial time tracking files (WEEK*_DAY*.md):**
1. Read each file
2. Verify info exists in STATUS.md/DECISIONS.md/TODO.md
3. Consolidate missing info:
   - Key learnings → STATUS.md
   - Decisions → DECISIONS.md
   - Metrics → STATUS.md
4. Delete files
5. Commit: `git rm ai/WEEK*.md && git commit -m "Remove time-tracking files - info consolidated"`

### 6. Prune STATUS.md

Extract current state only:
- Keep: Current metrics, active blockers, recent learnings (1-2 sessions)
- Delete: Old pivots, completed phases, historical architectures, resolved blockers

**Action:**
1. Create temp file with current state
2. Replace STATUS.md
3. Commit: `git add ai/STATUS.md && git commit -m "Compact STATUS.md - removed historical content"`

### 7. Organize DECISIONS.md

**If has superseded decisions:**
1. Create ai/decisions/superseded-YYYY-MM.md
2. Move reversed/replaced decisions there
3. Keep only active decisions in main file

**If >50 decisions or hard to navigate:**
1. Create topic files: ai/decisions/architecture.md, ai/decisions/database.md, etc.
2. Move related decisions to topic files
3. Keep index in main DECISIONS.md linking to topics

**Delete entirely:** Reversed decisions with no historical value

Commit after each change.

### 8. Clean TODO.md

- Delete all completed tasks (no "Done" sections)
- Keep only pending/in-progress work
- Commit: `git add ai/TODO.md && git commit -m "Clean TODO.md - removed completed tasks"`

### 9. Prune PLAN.md

- Delete completed phases
- Keep current phase + dependencies for next 1-2 phases
- Archive major phase completions to DECISIONS.md if valuable
- Commit changes

### 10. Remove Anti-Patterns

**ai/archive/:**
1. Review contents
2. Consolidate valuable info to appropriate files
3. Delete directory: `git rm -r ai/archive && git commit -m "Remove ai/archive - use git history"`

**Code in ai/:**
1. Identify code files (*.py, *.rs, *.ts, etc.)
2. Ask: "Move [files] to src/ or delete?"
3. Move or delete as directed

**Duplicate docs/ and ai/:**
- Identify overlapping content
- Keep permanent docs in docs/, working context in ai/

### 11. Optimize Token Efficiency

**Check session file sizes:**
```bash
wc -l ai/*.md
```

**Move detailed content to subdirectories:**

**If RESEARCH.md has detailed research:**
1. Identify research topics with substantial detail
2. Extract to ai/research/{topic}.md
3. Update RESEARCH.md to index format:
   ```markdown
   ## Database Selection (2025-01-15)
   **Finding:** PostgreSQL best fit
   **Decision:** Proceeding with PostgreSQL
   → Details: ai/research/database-comparison.md
   ```
4. Commit: `git add ai/RESEARCH.md ai/research/ && git commit -m "Move detailed research to subdirectory - token efficiency"`

**If DECISIONS.md difficult to navigate:**
1. Check for superseded decisions → move to ai/decisions/superseded-YYYY-MM.md
2. If still hard to navigate, split by topic → ai/decisions/{architecture,database,etc}.md
3. Keep index in DECISIONS.md with recent decisions
4. Commit changes

**If design content in root:**
1. Move to ai/design/{component}.md
2. Reference from PLAN.md or STATUS.md
3. Commit: `git add ai/design/ && git commit -m "Organize design specs in subdirectory"`

**Verify subdirectories exist:**
```bash
mkdir -p ai/research ai/design ai/decisions
```

**Principle:**
- Session files = current/active work only (historical content pruned)
- Reference files = detailed content (loaded only when needed)
- Result: Load only relevant context per session

### 12. Optimize AGENTS.md

**Check symlink relationship:**
```bash
ls -la AGENTS.md CLAUDE.md
```
Expected: `CLAUDE.md → AGENTS.md` (AGENTS.md is primary file, CLAUDE.md symlink for Claude Code)

**Optimize format (PRACTICES.md lines 273-295):**

Verify AGENTS.md uses machine-readable structure:
- [ ] Tables, lists, code blocks (not prose)
- [ ] Clear ## sections with logical hierarchy
- [ ] Well-structured: easy to parse, comprehensive coverage
- [ ] No duplication with ai/ files (use pointers: "See ai/STATUS.md for current state")
- [ ] Quality over brevity: well-structured 500 lines > poorly organized 100 lines

**What belongs in AGENTS.md:**
- ✅ Project overview, tech stack, architecture
- ✅ Build/test/deploy commands
- ✅ Code standards, naming conventions
- ✅ Development workflow
- ✅ Project structure explanation
- ✅ Pointers to ai/ files: "See ai/STATUS.md for current state"

**What does NOT belong:**
- ❌ Current issues, blockers (→ ai/STATUS.md)
- ❌ Active tasks, TODO items (→ ai/TODO.md)
- ❌ Recent learnings, metrics (→ ai/STATUS.md)
- ❌ Detailed tactical roadmap (→ ai/PLAN.md)
- ❌ Duplicating ai/ file content

**Verify ai/ structure documented with purpose:**
```markdown
## Project Structure

| Directory | Purpose |
|-----------|---------|
| ai/ | **AI session context** - Agent workspace for tracking state across sessions |

### AI Context Organization

**Purpose:** AI uses ai/ to maintain continuity between sessions

**Session files** (ai/ root - read every session):
- STATUS.md — Current state, metrics, blockers (read FIRST)
- TODO.md — Active tasks only
- DECISIONS.md — Active architectural decisions
- RESEARCH.md — Research findings index
- PLAN.md — Strategic roadmap (optional)

**Reference files** (subdirectories - loaded only when needed):
- research/ — Detailed research
- design/ — Design specifications
- decisions/ — Superseded/split decisions

**Purpose:** AI uses ai/ to maintain continuity between sessions. Session files kept current/active only for token efficiency. Detailed content in subdirectories loaded on demand.
```

**Claude Code integration:**
- [ ] Mention custom slash commands if in .claude/commands/
- [ ] Note MCP servers if configured
- [ ] Document project-specific hooks if used

**Action:**
1. Read AGENTS.md
2. Add ai/ directory explanation if missing (session context management)
3. Identify prose sections → convert to tables/lists
4. Find duplicated ai/ content → replace with pointers
5. Verify comprehensive coverage (commands, standards, structure)
6. Ensure clear ## sections
7. Commit: `git add AGENTS.md && git commit -m "Optimize AGENTS.md - structured format, explain ai/ purpose"`

## Verification

Check:
- [ ] No time estimates in PLAN.md (unless external deadline confirmed)
- [ ] No progress markers or artificial time tracking
- [ ] STATUS.md focused on current state only (no historical content)
- [ ] DECISIONS.md organized (superseded moved, topics split if needed)
- [ ] TODO.md has no completed tasks (only active work)
- [ ] PLAN.md focused on current + next 1-2 phases
- [ ] RESEARCH.md is index only (detailed research in ai/research/)
- [ ] Subdirectories exist: ai/research/, ai/design/, ai/decisions/
- [ ] Session files focused on current/active work (detailed content in subdirs)
- [ ] No ai/archive/ directory
- [ ] No code files in ai/
- [ ] CLAUDE.md → AGENTS.md symlink correct
- [ ] AGENTS.md uses tables/lists (not prose)
- [ ] AGENTS.md has clear ## sections
- [ ] AGENTS.md explains ai/ is for AI session context
- [ ] AGENTS.md has no duplication with ai/ files
- [ ] AGENTS.md comprehensive (commands, standards, structure)

## Summary

Show:
```markdown
## Update Complete

**Time-tracking artifacts:**
- PLAN.md: Removed [X] estimates, [Y] progress markers
- Deleted [N] WEEK*_DAY*.md files (info consolidated)

**File maintenance:**
- STATUS.md: Pruned [removed historical content - current state only]
- DECISIONS.md: [action taken - organized/split/cleaned]
- TODO.md: Removed [N] completed tasks
- PLAN.md: Pruned to current + next phases
- RESEARCH.md: [converted to index / kept as-is]

**Token efficiency:**
- Session files: [focused on current/active work only]
- Moved [N] detailed docs to subdirectories (loaded only when needed)
- Subdirectories: research/ ([N] files), design/ ([N] files), decisions/ ([N] files)
- Result: Load only relevant context per session (not all details every time)

**AGENTS.md optimization:**
- Symlink: CLAUDE.md → AGENTS.md ✓
- Format: [converted X prose sections to tables/lists]
- Duplication: [removed Y duplicated sections, added pointers]
- Structure: [X clear sections, comprehensive coverage]
- AI context explanation: [added / already present]

**Anti-patterns fixed:**
- [list if any: removed ai/archive/, moved code files, deduplicated docs]

**Result:** ai/ directory optimized for AI session context management
- Session files current/active work only (historical content pruned)
- Reference files organized in subdirectories
- Token-efficient structure (load only what's needed per session)

**Note:** All historical content preserved in git history
```

## Guidelines

- Always ask before deleting files
- Verify info consolidated before deletion
- Commit after each logical change
- If user wants to keep time estimates, ask about external deadlines
- Files with real dates (ANALYSIS_2025-11-05.md) are good - keep them
- Focus: Keep files focused on current/relevant info without substantial historical content
