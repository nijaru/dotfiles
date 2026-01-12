---
description: Analyze code and suggest concrete refactorings with before/after examples.
---

# Refactor

Analyze code and suggest concrete refactorings.

## Workflow

1. **Identify scope** - file, function, or module
2. **Analyze** - check against refactoring checklist
3. **For large refactors** - consider architectural planning
4. **Propose changes** - specific before/after with priority order
5. **Offer to implement** - if user approves

## Refactoring Checklist

### Naming

| Issue                  | Action                   |
| ---------------------- | ------------------------ |
| Unclear names          | Rename with intent       |
| `_v2`, `_new` suffixes | Replace with descriptive |
| Magic numbers          | Extract to constants     |
| Inconsistent style     | Align with codebase      |

### Size

| Metric         | Threshold | Action                 |
| -------------- | --------- | ---------------------- |
| Function lines | >40       | Extract helpers        |
| Parameters     | >4        | Parameter object       |
| Nesting depth  | >3        | Early return / extract |
| File lines     | >400      | Split module           |

### Smells

| Smell                            | Action           |
| -------------------------------- | ---------------- |
| Duplication (3+ lines, 2+ times) | Extract function |
| Feature envy                     | Move method      |
| Long param list                  | Parameter object |
| Primitive obsession              | Value types      |
| Dead code                        | Delete           |
| Speculative generality           | Delete           |

## Output Format

```
## Refactoring: [Name]

Location: file:line
Problem: [Why it matters]

Before:
[code]

After:
[code]

Benefit: [Improvement]
```

## Summary

```
## Refactoring Plan

Priority:
1. [Quick win] - file:line
2. [Medium effort] - file:line
3. [Larger change] - file:line

Risk: [Safe / Needs tests first]

Implement these changes?
```
