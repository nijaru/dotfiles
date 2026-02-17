---
name: refactor
description: Analyze code and suggest concrete refactorings with before/after examples.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Refactor

Analyze code and suggest concrete refactorings. Analyze directly in main session.

## Workflow

1. **Identify scope** - file, function, or module
2. **Analyze** - check against refactoring checklist
3. **Propose changes** - specific before/after with priority order
4. **Offer to implement** - if user approves

For genuine architecture work (new module boundaries, dependency restructuring, type hierarchy redesign), suggest spawning a `designer` subagent. Routine multi-file changes (renames, interface updates, moving functions) don't need a designer.

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

### Structure

- Multiple responsibilities -> Split
- Deep nesting -> Early returns
- God object -> Decompose

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
