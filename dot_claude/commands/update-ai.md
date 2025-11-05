Audit and clean up existing AI agent context files to remove time-tracking artifacts.

**Purpose**: Remove arbitrary time estimates and progress tracking from ai/ directory. Focus PLAN.md on dependencies, architecture, and scope.

## Tasks

### 1. Analyze Current State

Check for:
- ai/ directory exists
- PLAN.md exists
- Time-based artifacts in PLAN.md:
  - "Week X Day Y" markers
  - "~X-Y days" estimates
  - Quarter-based timelines without external deadlines (Q1 2025, Q2 2025)
  - "_Last Updated: Week X Day Y_" datestamps
- Artificial time tracking files: `WEEK*_DAY*.md` (not real dates like `ANALYSIS_2025-11-05.md`)
- Detailed task breakdowns in PLAN.md that should be in TODO.md

### 2. Present Findings

Show user:
```markdown
## Audit Results

**PLAN.md issues found:**
- [ ] Time estimates ("~3-4 days")
- [ ] Progress markers ("Week 19 Day 5 ← YOU ARE HERE")
- [ ] Quarter timelines without external deadline
- [ ] Detailed task breakdowns (should be in TODO.md)
- [ ] Datestamps in updates

**Artificial time tracking files found:**
- ai/WEEK11_DAY1_SUMMARY.md (no real date)
- ai/research/WEEK19_DAY2_PLAN.md (no real date)
- [list all WEEK*_DAY*.md files]
- Note: Files with real dates (e.g., ANALYSIS_2025-11-05.md) are fine

**Recommendation**: Clean up [X] issues
```

### 3. Get User Approval

Ask: "Clean up time-tracking artifacts from ai/ directory?"

If no issues found, report "✓ ai/ directory follows best practices" and exit.

### 4. Clean Up PLAN.md

**Remove**:
- All "Week X Day Y" markers
- All "~X-Y days/weeks" estimates
- Quarter timelines (unless user confirms external deadline exists)
- "_Last Updated: Week X Day Y_" datestamps
- Progress indicators ("← YOU ARE HERE")

**Keep**:
- Dependencies (A before B)
- Technical architecture decisions
- Scope boundaries (what's in/out)
- Success criteria
- External deadlines (if confirmed by user)

**Move to TODO.md**:
- Detailed task breakdowns with sub-items
- "Planned Work" sections with implementation steps

**Example transformation**:

Before:
```markdown
## Milestones
| Phase | Timeline | Status |
|-------|----------|--------|
| Phase 1 | Q1 2025 | ← CURRENT |

**Week 19 Day 5+ ← YOU ARE HERE**

**Planned Work**:
1. **Feature X** (~3-4 days)
   - Sub-task A
   - Sub-task B
```

After:
```markdown
## Phases
| Phase | Status | Deliverables | Success Criteria |
|-------|--------|--------------|------------------|
| Phase 1 | ← CURRENT | [from original] | [from original] |

## Dependencies
[Extracted from context]
```

(Move "Planned Work" → TODO.md)

### 5. Consolidate Artificial Time Tracking Files

**CRITICAL**: Always read files before deleting to verify information is preserved!

For each artificial time tracking file (WEEK*_DAY*.md - no real date):

1. **Read the file** - Check what information it contains
2. **Verify consolidation** - Check if info already exists in:
   - STATUS.md (current state, recent achievements)
   - TODO.md (completed milestones, ongoing work)
   - DECISIONS.md (architectural choices)
   - PLAN.md (phase achievements)
3. **Extract missing info** - If anything important is NOT already documented:
   - Key achievements/metrics → STATUS.md or TODO.md
   - Technical decisions → DECISIONS.md
   - Performance results → STATUS.md
   - Bug fixes/learnings → STATUS.md
4. **Ask user** - Show what will be consolidated/deleted, get approval
5. **Delete the file** - Only after verifying info preserved
6. Commit: `git rm ai/WEEK*_DAY*.md && git commit -m "Clean up dated files (info consolidated to STATUS.md/TODO.md/DECISIONS.md)"`

**Example check**:
```bash
# Read file
cat ai/WEEK19_DAY2_SUMMARY.md

# Check if info already in TODO.md
grep -A20 "WritableDiskStorage" ai/TODO.md

# If info is there → safe to delete
# If NOT there → consolidate first, THEN delete
```

**Template for consolidation**:
```markdown
# In STATUS.md, add relevant findings:
## What Worked
- [Key learning from WEEK*_DAY*.md with commit hash]

# In DECISIONS.md, add architectural choices:
## YYYY-MM-DD: [Decision from WEEK*_DAY*.md]
**Context**: [situation]
**Decision**: [choice]
**Commits**: [hash]
```

### 6. Update File Descriptions

Ensure AGENTS.md reflects correct PLAN.md purpose:
```markdown
- ai/PLAN.md — Dependencies, architecture, scope (not time tracking)
```

### 7. Verify

Check:
- [ ] PLAN.md has no time estimates (unless external deadline confirmed)
- [ ] PLAN.md has no progress markers
- [ ] No artificial time tracking files (WEEK*_DAY*.md) in ai/ or ai/research/
- [ ] Files with real dates (e.g., ANALYSIS_2025-11-05.md) are fine to keep
- [ ] Key learnings consolidated to STATUS.md
- [ ] Architectural decisions in DECISIONS.md
- [ ] AGENTS.md updated

### 8. Summary

Show:
```markdown
## Cleanup Complete

**PLAN.md**: Removed [X] time estimates, [Y] progress markers
**Artificial time tracking files**: Consolidated [Z] WEEK*_DAY*.md files → STATUS.md/DECISIONS.md, deleted
**TODO.md**: Moved [N] detailed task breakdowns from PLAN.md

**Note**: Files with real dates (e.g., ANALYSIS_2025-11-05.md, BENCHMARK_NOV2025.md) were kept - those are good for tracking actual dates.

**Result**: ai/ directory now focuses on dependencies and architecture, not arbitrary time tracking.
```

## Notes

- Ask before deleting any files
- If user wants to keep quarters/estimates, ask why (external deadline? Scrum sprint? Funding milestone?)
- Focus: dependencies (what blocks what) > time estimates (how long it takes)
- Git preserves history - artificial time tracking files (WEEK*_DAY*.md) can be deleted safely
- Files with real dates/months (ANALYSIS_2025-11-05.md, BENCHMARK_NOV2025.md) are good - keep them
