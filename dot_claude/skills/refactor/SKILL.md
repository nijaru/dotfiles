---
name: refactor
description: >
  Analyze code and suggest concrete refactorings with before/after examples.
  Triggers on: "refactor", "refactor this", "clean up", "clean this up",
  "simplify", "this is messy", "too long", "too complex", "hard to read",
  "ugly code", "improve this", "how can I improve", "make this better",
  "extract", "rename", "split this".
  Use when code works but needs cleanup.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Refactor

Analyze code and suggest concrete refactorings. For large architectural changes, spawn designer subagent.

## Workflow

1. **Identify scope** - file, function, or module
2. **Analyze** - check against refactoring checklist
3. **For large refactors** - spawn `designer` subagent for architectural planning
4. **Propose changes** - specific before/after with priority order
5. **Offer to implement** - if user approves

## When to Use Designer Subagent

Spawn designer via Task tool when:

- Splitting a module into multiple files
- Changing class/type hierarchy
- Restructuring dependencies
- Anything touching 3+ files

For single-file refactors, analyze directly.

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

- Multiple responsibilities → Split
- Deep nesting → Early returns
- God object → Decompose

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
