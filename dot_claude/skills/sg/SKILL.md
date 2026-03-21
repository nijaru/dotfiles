---
name: sg
description: Use for structural code search and replace using ast-grep for high-confidence refactors.
allowed-tools: Bash, Read
---

# sg (ast-grep)

## 🎯 Core Mandates

- **Structural over Regex:** Use `sg` when you need to match code structures (functions, classes, blocks) rather than text patterns.
- **Syntactic Validity:** `sg` only operates on syntactically valid code. Fix syntax errors before running.
- **Mass Edit Safety:** Always use `--interactive` or verify with `sg scan` before applying `sg rewrite`.

## 🛠️ Technical Standards

### 1. Common Commands
| Task | Command | Purpose |
| :--- | :--- | :--- |
| **Search** | `sg run -p 'pattern'` | Search for a specific syntax pattern. |
| **Scan** | `sg scan` | Find patterns based on project-wide YAML rules. |
| **Rewrite** | `sg run -p 'pattern' -r 'replacement'` | Structural search and replace. |
| **Help** | `sg help` | View full CLI options. |

### 2. Pattern Matching
- Use `$$$` for matching multiple nodes (like function arguments).
- Use `$` followed by a name (e.g., `$FUNC`) to capture specific nodes.
- Filter by language: `sg run -l python -p '...'`.

### 3. Workflow
- Identify the structure you want to change.
- Draft the pattern using `sg run`.
- Verify matches with `sg scan`.
- Apply changes surgically.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "Grep is faster" | Grep is faster to type but slower and riskier for complex code changes. |
| "I'll use regex" | Regex doesn't understand syntax blocks. `sg` does. |
| "Pattern is simple" | Simple patterns often have hidden edge cases that `sg` handles natively. |
