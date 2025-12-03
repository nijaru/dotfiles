---
description: Generate PR description - asks permission before creating
argument-hint: "[target-branch]"
allowed-tools: Read, Grep, Glob, Bash(command:git*), Bash(command:gh*)
---

Generate a pull request for the current branch. Target: $1 (default: main)

## Steps

1. **Analyze changes**: `git log main..HEAD` and `git diff main...HEAD`
2. **Run /code-review** first if not already done
3. **Generate PR content**:

```markdown
## Summary

[1-3 bullet points on WHY these changes, not WHAT]

## Changes

[Categorized list: Added/Changed/Fixed/Removed]

## Testing

[How this was tested, what to verify]

## Breaking Changes

[If any - migration steps needed]
```

4. **Present draft** to user for review
5. **Ask explicitly**: "Create this PR? (yes/no)"

Do NOT run `gh pr create` without explicit user approval.

$ARGUMENTS
