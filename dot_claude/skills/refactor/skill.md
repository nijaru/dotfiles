---
name: refactor
description: >
  Automatically suggests refactorings when context indicates code improvement needed.
  Triggers on: "refactor this", "clean up", "simplify", "this is messy",
  "too long", "too complex", or when reviewing code with obvious smells.
allowed-tools: Read, Grep, Glob, Bash(command:git*)
---

# Refactor Skill

Analyze code and suggest concrete refactorings when the context suggests improvement is needed.

## Activation Triggers

- User says: "refactor this", "clean up", "simplify", "too complex"
- User mentions: "messy", "ugly", "hard to read", "confusing"
- During code review when smells are detected
- When user asks "how can I improve this?"
- After implementing a feature (optional cleanup pass)

## Analysis Checklist

### 1. Naming

| Issue                          | Action                          |
| ------------------------------ | ------------------------------- |
| Unclear names                  | Suggest specific renames        |
| Inconsistent naming            | Align with codebase conventions |
| Vague suffixes (`_v2`, `_new`) | Replace with descriptive names  |
| Magic numbers                  | Extract to named constants      |

### 2. Function/Method Size

| Metric                | Threshold | Action                       |
| --------------------- | --------- | ---------------------------- |
| Lines                 | >40       | Extract helper functions     |
| Parameters            | >4        | Use parameter object         |
| Nesting depth         | >3        | Extract or early return      |
| Cyclomatic complexity | >10       | Split into smaller functions |

### 3. Class/Module Size

| Metric           | Threshold | Action                                |
| ---------------- | --------- | ------------------------------------- |
| Lines            | >400      | Split into focused modules            |
| Methods          | >15       | Extract related methods to new class  |
| Responsibilities | >1        | Apply Single Responsibility Principle |

### 4. Duplication

- Identify repeated code blocks (3+ lines appearing 2+ times)
- Suggest extraction into shared function
- Show before/after

### 5. Code Smells

| Smell                  | Detection                                   | Refactoring                |
| ---------------------- | ------------------------------------------- | -------------------------- |
| Feature Envy           | Method uses another class more than its own | Move to that class         |
| Long Parameter List    | >4 params                                   | Introduce Parameter Object |
| Data Clumps            | Same params appear together                 | Extract class              |
| Primitive Obsession    | Strings/ints for domain concepts            | Create value types         |
| Switch Statements      | Type-based switching                        | Polymorphism               |
| Speculative Generality | Unused abstractions                         | Delete                     |
| Dead Code              | Unused functions/variables                  | Delete                     |

### 6. Structure

- Functions doing multiple things → Split
- Deep nesting → Early returns, extract
- God objects → Decompose by responsibility

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

End with:

1. **Priority order**: Which refactorings to do first (quick wins → larger efforts)
2. **Risk assessment**: Safe changes vs. need tests first
3. **Verdict**: Offer to implement the refactorings if user approves
