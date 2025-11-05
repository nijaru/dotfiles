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
- Dated files: `WEEK*_DAY*.md`, `*_OCT23.md`, `SUMMARY_*.md`
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

**Dated files found:**
- ai/WEEK11_DAY1_SUMMARY.md
- ai/research/WEEK19_DAY2_PLAN.md
- [list all]

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

### 5. Consolidate Dated Files

For each dated file (WEEK*_DAY*.md, etc.):

1. Extract key learnings/decisions
2. Add to STATUS.md (if current) or DECISIONS.md (if permanent)
3. Delete the dated file
4. Commit: `git rm ai/WEEK*_DAY*.md && git commit -m "Clean up dated files, consolidated to STATUS.md/DECISIONS.md"`

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
- [ ] No dated files in ai/ or ai/research/
- [ ] Key learnings consolidated to STATUS.md
- [ ] Architectural decisions in DECISIONS.md
- [ ] AGENTS.md updated

### 8. Summary

Show:
```markdown
## Cleanup Complete

**PLAN.md**: Removed [X] time estimates, [Y] progress markers
**Dated files**: Consolidated [Z] files → STATUS.md/DECISIONS.md, deleted
**TODO.md**: Moved [N] detailed task breakdowns from PLAN.md

**Result**: ai/ directory now focuses on dependencies and architecture, not arbitrary time tracking.
```

## Notes

- Ask before deleting any files
- If user wants to keep quarters/estimates, ask why (external deadline? Scrum sprint? Funding milestone?)
- Focus: dependencies (what blocks what) > time estimates (how long it takes)
- Git preserves history - dated files can be deleted safely
