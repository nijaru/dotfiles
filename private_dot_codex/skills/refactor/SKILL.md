---
name: refactor
description: >
  Analyze code and suggest concrete refactorings.
  Triggers on: "refactor this", "clean up", "simplify", "this is messy",
  "too long", "too complex", or when reviewing code with obvious smells.
metadata:
  short-description: Suggest and apply refactorings
---

# Refactor

Analyze code and suggest concrete refactorings when the context suggests improvement is needed.

## Triggers

- "refactor this", "clean up", "simplify", "too complex"
- "messy", "ugly", "hard to read", "confusing"
- During code review when smells are detected
- "how can I improve this?"

## Analysis Checklist

### 1. Naming

| Issue                          | Action                         |
| ------------------------------ | ------------------------------ |
| Unclear names                  | Suggest specific renames       |
| Vague suffixes (`_v2`, `_new`) | Replace with descriptive names |
| Magic numbers                  | Extract to named constants     |

### 2. Function/Method Size

| Metric        | Threshold | Action                   |
| ------------- | --------- | ------------------------ |
| Lines         | >40       | Extract helper functions |
| Parameters    | >4        | Use parameter object     |
| Nesting depth | >3        | Extract or early return  |

### 3. Code Smells

| Smell               | Detection                                   | Refactoring                |
| ------------------- | ------------------------------------------- | -------------------------- |
| Feature Envy        | Method uses another class more than its own | Move to that class         |
| Long Parameter List | >4 params                                   | Introduce Parameter Object |
| Data Clumps         | Same params appear together                 | Extract class              |
| Primitive Obsession | Strings/ints for domain concepts            | Create value types         |
| Dead Code           | Unused functions/variables                  | Delete                     |

### 4. Structure

- Functions doing multiple things -> Split
- Deep nesting -> Early returns, extract
- God objects -> Decompose by responsibility

## Output Format

For each refactoring:

```
## [Refactoring Name]

**Location:** `file:line`

**Problem:** [What's wrong and why it matters]

**Before:**
[current code]

**After:**
[refactored code]

**Benefits:** [Why this improves the code]
```

## Summary

1. **Priority order**: Quick wins -> larger efforts
2. **Risk assessment**: Safe changes vs. need tests first
3. **Verdict**: Offer to implement if user approves
