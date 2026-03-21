---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent configurations, and handling source/destination drift safely.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi (The Dotfiles Orchestrator)

## 🎯 Core Mandates

- **Pre-flight Check:** Run `chezmoi status` BEFORE every `apply`. No exceptions.
- **Verification First:** If `status` shows `D` (Deleted) or `DA` for files you just created, STOP. Verify they are tracked with `chezmoi add`.
- **Target vs Source:** Always be explicit about whether you are editing the **Source** (`dot_...`) or the **Target** (`~/...`).
- **Diff before Force:** Never use `apply --force` if `chezmoi status` shows unexpected changes. Run `chezmoi diff` first.

## 🛠️ Technical Standards

### 1. The Standard Workflow
| Step | Action | Command |
| :--- | :--- | :--- |
| **1. Check** | Inspect current drift | `chezmoi status` |
| **2. Edit** | Modify the source | `edit dot_path/to/file` |
| **3. Verify** | Review the drift | `chezmoi diff` |
| **4. Apply** | Sync to destination | `chezmoi apply` |
| **5. Commit** | Track the change | `git add . && git commit -m "msg"` |

### 2. Status Legend (Agent Cheat Sheet)
- `M`: Modified (Safe to apply).
- `A`: Added in Source (Safe to apply).
- `D`: Deleted in Source (Danger: Destination will be deleted).
- `DA`: Deleted in Source / Added in Destination (Conflict).

### 3. Global Configuration
- **CLAUDE.md**: The primary reference for all agents. Keep it in sync.
- **Skills**: Shared skills live in `dot_claude/skills/`.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "It's a small sync" | Small syncs are where `apply --force` deletions happen. Check status. |
| "I'll add it to git later" | Chezmoi status relies on the link between source and target. Track immediately. |
| "I'm in the source repo" | Being in the source doesn't mean the destination is safe. Use `chezmoi` tools. |
