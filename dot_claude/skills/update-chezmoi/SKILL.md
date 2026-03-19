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
2. Shared-capable tools should consume it via `~/.agents/skills`.
3. Mirror only where a tool still requires its own root:
   - `private_dot_codex/skills/symlink_my-skill`
4. Keep tool-specific skills in the tool's own skills directory when needed.
5. Symlink file content should point to `/Users/nick/.claude/skills/my-skill`.

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

Current preference:

- Shared path: `~/.agents/skills` (alias of `~/.claude/skills`)
- Gemini CLI: use the shared path for shared skills
- Pi: add the shared path in `~/.pi/agent/settings.json`
- Crush: add the shared path in `~/.config/crush/crush.json`
- OpenCode: use the shared path and disable duplicate `.claude/skills` scanning

## 🚫 Anti-Rationalization

| Excuse                  | Reality                                                             |
| :---------------------- | :------------------------------------------------------------------ |
| "I'll apply later"      | Drift between source and destination causes configuration bugs.     |
| "I'll manually link it" | Manual links are lost on `chezmoi apply --force`. Use source files. |
