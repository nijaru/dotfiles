---
description: Analyze code and suggest refactorings
---

Analyze code and suggest concrete refactorings with before/after examples.

1. **Identify scope**: File, function, or module
2. **For large refactors** (3+ files): Spawn `designer` subagent via Task tool
3. **Check against**:
   - Naming: unclear, `_v2`/`_new`, magic numbers
   - Size: functions >40 lines, files >400 lines, params >4, nesting >3
   - Smells: duplication, feature envy, dead code, primitive obsession
   - Structure: multiple responsibilities, deep nesting
4. **Propose changes** with priority order
5. **Offer to implement**

Output format:

```
## Refactoring: [Name]
Location: file:line
Problem: [Why]

Before:
[code]

After:
[code]

## Plan
1. [Quick win] - file:line
2. [Medium] - file:line
3. [Larger] - file:line

Risk: Safe / Needs tests
Implement?
```
