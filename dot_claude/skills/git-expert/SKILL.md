---
name: git-expert
description: Use for complex version control operations, semantic diffs (sem), merge drivers (weave), and the GitHub CLI (gh).
allowed-tools: Bash, Read, Write, Edit
---

# Git Expert (Semantic Stack)

## 🎯 Core Mandates

- **Discovery First:** Before using any VCS tool, check for `.git/`. If present and `.jj/` is absent, use `git` as the primary interface.
- **Semantic Insight:** Use `sem diff` for entity-level changes (functions, classes) and `git dft` (difftastic) for structural diffing.
- **Clean History:** Maintain atomic, logical commits. One change = one commit.

## 🛠️ Technical Standards

### 1. Advanced Diffing
| Tool | Task | Command | Purpose |
| :--- | :--- | :--- | :--- |
| **sem** | `sem diff` | `sem diff` | Entity-level changes (functions/classes). |
| **difftastic** | `git dft` | `git dft` | Structural diffing that ignores syntax noise. |
| **delta** | `git log -p` | `git log -p` | Colorized diffing for history review. |

### 2. Semantic Merge (Weave)
- **Automatic:** `weave` is configured globally as a merge driver. Most merges use it automatically.
- **Claiming Entities:** For high-contention files, use `weave claim <entity>` before editing to prevent merge conflicts. Run `weave release <entity>` after committing.
- **Conflicts:** Use `weave summary` to parse structured conflict markers.

### 3. GitHub CLI (gh)
- **PR Management:** `gh pr create`, `gh pr checkout`, `gh pr list`.
- **Repo Info:** `gh repo view`, `gh repo clone`.
- **Issue Tracking:** `gh issue list`, `gh issue view`.

### 4. Git Standards
- **Commit Messages:** Follow the "WHY" principle. Concise summary first, followed by rationale if non-obvious.
- **Exclusion:** Use `.git/info/exclude` for agent files (ai/, .tasks/) as per `git-local-exclude`.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "Line diff is fine" | You're missing the structural context. Use `sem` or `dft`. |
| "I'll use the git UI" | The `gh` CLI is faster and more automatable for agents. |
| "I'll use .gitignore" | Use `git-local-exclude` for files only YOU (the agent) use. |
| "I'll claim later" | If multiple agents are working, `weave claim` is essential to prevent conflicts. |
