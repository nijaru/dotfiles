---
name: update-chezmoi
description: Use when modifying dotfiles, global AI config (~/.claude/CLAUDE.md), or syncing skills across agents.
allowed-tools: Read, Write, Edit, Bash
---

# Update Chezmoi

Manage global agent configurations and skills through the `chezmoi` dotfiles system.

## 🎯 Mandates

- **Source of Truth:** `dot_claude/CLAUDE.md` is the primary reference. All agents link to it.
- **Automation:** Use `chezmoi apply` immediately after modifications.
- **Sync:** Commit and push to remote `dotfiles` after verifying local changes.

## 🛠️ Standards

### 1. Skill Management

To add a global skill:

1. Create `~/.claude/skills/my-skill/SKILL.md`.
2. Add symlink files to `chezmoi` source:
   - `dot_gemini/skills/symlink_my-skill`
   - `private_dot_codex/skills/symlink_my-skill`
3. File content: `/Users/nick/.claude/skills/my-skill`.

### 2. Configuration Sync

| Task                    | Command                                                                    |
| :---------------------- | :------------------------------------------------------------------------- |
| Update Global CLAUDE.md | `edit ~/.claude/CLAUDE.md && chezmoi apply`                                |
| Track edited file       | `chezmoi add ~/.claude/skills/my-skill/SKILL.md`                           |
| Commit to chezmoi       | `cd $(chezmoi source-path) && git add path/to/file && git commit -m "msg"` |
| Sync to Remote          | `cd $(chezmoi source-path) && git push`                                    |
| Deploy to New Machine   | `chezmoi update`                                                           |

**Git staging:** Use `git add <specific-file>` — never `git add .` or `git add -p` (interactive). Always add the correct source path (e.g. `dot_claude/skills/...`), not the target path.

### 3. Symlink Pattern

Files named `symlink_NAME` in the source directory automatically resolve to symlinks in the target location.

## 🚫 Anti-Rationalization

| Excuse                  | Reality                                                             |
| :---------------------- | :------------------------------------------------------------------ |
| "I'll apply later"      | Drift between source and destination causes configuration bugs.     |
| "I'll manually link it" | Manual links are lost on `chezmoi apply --force`. Use source files. |
