---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent skills/config, and handling chezmoi source/destination workflows.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi

## Mandates

- **Plain files:** Use Edit/Write tools on the destination (`~/`), then `chezmoi add <dest-path>` to sync to source.
- **Template files (`.tmpl`):** `chezmoi add` doesn't work — edit the source file directly (`~/.local/share/chezmoi/`) with Edit/Write tools, then `chezmoi apply --force`.
- **Always `--force` with `apply`.** Without it, chezmoi hangs waiting for a TTY that doesn't exist in agent contexts.
- **`chezmoi edit` launches `$EDITOR` — never use it from an agent.**

## Standards

### 1. Commands

| Command                   | Direction            | When to use                                          |
| :------------------------ | :------------------- | :--------------------------------------------------- |
| `chezmoi add <dest-path>` | destination → source | After editing a plain destination file with tools    |
| `chezmoi re-add`          | destination → source | Bulk re-sync all modified plain destinations         |
| `chezmoi apply --force`   | source → destination | After editing source directly (templates/encryption) |

### 2. Workflow

```bash
# Plain files — edit destination, sync to source
# (use Edit/Write tools on ~/.claude/skills/my-skill/SKILL.md)
chezmoi add ~/.claude/skills/my-skill/SKILL.md

# Template files — edit source directly, deploy
# (use Edit/Write tools on ~/.local/share/chezmoi/dot_.../file.tmpl)
chezmoi apply --force

# Commit either way
cd ~/.local/share/chezmoi
git add dot_claude/skills/my-skill/SKILL.md
git commit -m "type(scope): msg"
git push
```

### 3. Status Legend

- `M`: Modified — safe to apply
- `A`: Added in source — safe to apply
- `D`: Deleted in source — destination will be deleted
- `DA`: Conflict — deleted in source, added in destination

### 4. Skill Management

New skill: create under `~/.local/share/chezmoi/dot_claude/skills/my-skill/SKILL.md`, then `chezmoi apply --force`.

Untracked plugin skill: `chezmoi add ~/.claude/skills/my-skill/SKILL.md` to pull into source, then commit.

Shared path across agents: `~/.agents/skills` (alias of `~/.claude/skills`).

| Agent       | Config                                                   |
| :---------- | :------------------------------------------------------- |
| Codex       | shared path directly                                     |
| Gemini CLI  | shared path directly                                     |
| Pi          | `~/.pi/agent/settings.json`                              |
| Crush       | `~/.config/crush/crush.json`                             |
| OpenCode    | shared path, disable duplicate `.claude/skills` scanning |
| Antigravity | `~/.gemini/antigravity/skills` → shared path             |

### 5. Symlink Pattern

Files named `symlink_NAME` in source resolve to symlinks at the destination.

## Anti-Rationalization

| Excuse                             | Reality                                                                    |
| :--------------------------------- | :------------------------------------------------------------------------- |
| "I'll just edit the source file"   | Use `chezmoi edit --apply` — it handles templates and encryption properly. |
| "I'll use `chezmoi add` on a tmpl" | `add`/`re-add` don't work with templates. Use `chezmoi edit` instead.      |
| "I'll skip `--force`"              | Chezmoi hangs waiting for a TTY that doesn't exist in agent contexts.      |
| "I'll manually link it"            | Manual links are lost on `apply --force`. Use source files.                |
