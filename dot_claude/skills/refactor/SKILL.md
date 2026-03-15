---
name: refactor
description: Use when analyzing or implementing code improvements, simplifying complex logic, or reducing technical debt. Trigger on large functions (>40 lines), deep nesting (>3), or duplicated code.
allowed-tools: Bash, Read, Grep, Glob, Edit, Task
---

# Refactor (Technical Excellence)

## 🎯 Core Mandates

- **Surgical Precision:** Apply targeted changes that improve readability without altering behavior.
- **Evidence-Driven:** Identify specific code smells (e.g., God objects, primitive obsession) before proposing changes.
- **Verification:** Always verify refactorings with existing or new tests.
- **Tone:** Be authoritative and directive in your suggestions.

## 🛠️ Refactoring Standards

### 1. Naming & Syntax
- **Intent-based:** Rename variables/functions to reflect *why* they exist, not *what* they are.
- **No Suffixes:** Eliminate `_v2`, `_new`, or `_old`.
- **Constants:** Extract all magic numbers and strings to named constants.

### 2. Complexity Limits
- **Function Length:** Split functions exceeding 40 lines.
- **Parameter Count:** Use parameter objects for functions with >4 arguments.
- **Nesting Depth:** Maximum depth of 3; use early returns and guard clauses to flatten logic.
- **File Size:** Modules >400 lines must be decomposed into smaller files.

### 3. Code Smells
- **Duplication:** Extract logic appearing 2+ times into a helper.
- **Dead Code:** Delete speculative generality or unused functions immediately.
- **Feature Envy:** Move methods to the objects they interact with most.

## 📋 Proposal Format

```markdown
## Refactoring: [Specific Component]

**Location:** `file:line`
**Problem:** [Concise technical reason for change]

**Before:**
[code]

**After:**
[code]

**Benefit:** [Specific metric: readability, testability, or performance]
```

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "The code is working, don't touch it." | "Working" code is a liability if it's unmaintainable or overly complex. |
| "I'll refactor this later." | Technical debt accumulates faster than it can be repaid; refactor during implementation. |
| "Adding one more 'if' is faster." | Quick fixes lead to fragile "spaghetti" logic that hides bugs. |

## 🛠️ Escalation

- For **architectural shifts** (dependency restructuring, new module boundaries), suggest spawning a `designer` subagent.
- For **routine cleanup** (renames, interface updates, moving methods), execute directly.
