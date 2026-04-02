---
name: jj
description: Use for version control when a repository contains a .jj/ directory. Focuses on the "revision-first" workflow and conflict-object management.
allowed-tools: Bash, Read
---

# jj (Jujutsu Version Control)

## Core Mandates

- **Discovery First:** Before using any VCS tool, check for `.jj/`. If present, use `jj` as the primary interface.
- **Logless Workflow:** Every change in the working copy is automatically snapshotted. No manual `git add`.
- **Conflict Management:** Conflicts in `jj` are first-class objects in the graph. You MUST resolve or `jj describe` them; do not leave the graph in an ambiguous state.

## Technical Standards

### 1. Discovery & State
```bash
# Check if repo uses jj
ls -d .jj/ 2>/dev/null && echo "Using jj" || echo "Using git"

# Check status and where the working copy (@) is
jj st
```

### 2. Revision Lifecycle
| Task | Command | Purpose |
| :--- | :--- | :--- |
| **New Change** | `jj new` | Create a child revision and edit it. |
| **Describe** | `jj desc -m "msg"` | Set or update the revision's description. |
| **Absorb** | `jj absorb` | Automatically move changes into the stack of mutable revisions. |
| **Undo** | `jj undo` | Revert the last operation (safe recovery). |

### 3. Handling Conflicts
- **Detect:** Conflicts appear in `jj st` and `jj log`.
- **Resolve:** Edit the files to resolve markers, then `jj describe` to confirm the fix.
- **Avoid:** Do not `jj git push` if conflicts exist in the current stack.

## jj vs. Git for Agents

| Factor | jj Mindset | Git Mindset |
| :--- | :--- | :--- |
| **Staging** | Automatic (Snapshotting) | Manual (`git add`) |
| **Stashing** | Use `jj new` | Use `git stash` |
| **Commits** | "Revisions" (can be empty/anonymous) | "Commits" (require message) |
| **Pushing** | `jj git push` | `git push` |

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll stage this later" | There's no staging in `jj`. Snapshotting is automatic. |
| "I'm lost in the graph" | Run `jj log` to visualize the stack and `jj st` to see where you are (`@`). |
| "Git commands failed" | If `.jj/` exists, standard `git` commands may conflict with the `jj` working copy. Use `jj`. |
