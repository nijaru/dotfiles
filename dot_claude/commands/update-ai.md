Audit and maintain AI agent context files following current best practices.

**Purpose**: Apply file maintenance practices to ai/ directory. Remove time-tracking artifacts, prune historical content, organize decisions, keep files current.

**Reference**: github.com/nijaru/agent-contexts PRACTICES.md

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

**Anti-patterns:**
- ai/archive/ directory exists (use git instead)
- Code files in ai/ (belongs in src/)
- Duplicate content between docs/ and ai/

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

**Anti-patterns:**
- [ ] ai/archive/ exists
- [ ] Code files in ai/
- [ ] Duplicate docs/ and ai/ content

**Files with real dates (GOOD - keeping):**
- ai/research/ANALYSIS_2025-11-05.md
- ai/BENCHMARK_NOV2025.md
```

If no issues: "✓ ai/ directory follows best practices" and exit.

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

### 11. Update AGENTS.md

Ensure it reflects correct file purposes:
```markdown
- ai/PLAN.md — Dependencies, architecture, scope (optional, only if 3+ phases)
- ai/STATUS.md — Current state (read first, updated every session)
- ai/TODO.md — Active tasks only
- ai/DECISIONS.md — Active architectural decisions
- ai/RESEARCH.md — Research index
- ai/research/ — Research findings (optional)
- ai/design/ — Design documents (optional)
```

## Verification

Check:
- [ ] No time estimates in PLAN.md (unless external deadline confirmed)
- [ ] No progress markers or artificial time tracking
- [ ] STATUS.md focused on current state only
- [ ] DECISIONS.md organized (superseded moved, topics split if needed)
- [ ] TODO.md has no completed tasks
- [ ] PLAN.md focused on current + next 1-2 phases
- [ ] No ai/archive/ directory
- [ ] No code files in ai/
- [ ] AGENTS.md updated

## Summary

Show:
```markdown
## Update Complete

**Time-tracking artifacts:**
- PLAN.md: Removed [X] estimates, [Y] progress markers
- Deleted [N] WEEK*_DAY*.md files (info consolidated)

**File maintenance:**
- STATUS.md: Pruned to [current size] (removed historical content)
- DECISIONS.md: [action taken - organized/split/cleaned]
- TODO.md: Removed [N] completed tasks
- PLAN.md: Pruned to current + next phases

**Anti-patterns fixed:**
- [list if any: removed ai/archive/, moved code files, deduplicated docs]

**Result:** ai/ directory current, focused, efficient (minimal irrelevant content)

**Note:** All historical content preserved in git history
```

## Guidelines

- Always ask before deleting files
- Verify info consolidated before deletion
- Commit after each logical change
- If user wants to keep time estimates, ask about external deadlines
- Files with real dates (ANALYSIS_2025-11-05.md) are good - keep them
- Focus: Keep files focused on current/relevant info without substantial historical content
