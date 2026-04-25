---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent skills/config, and handling chezmoi source/destination workflows.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi

## Mandates

- **Plain files:** Use Edit/Write tools on the destination (`~/`), then `chezmoi add <dest-path>` to sync to source.
- **Sync immediately — never batch.** Run `chezmoi add` right after each coherent edit (or tight group of edits), not at the end of a long session. Any destination edit not yet synced to source is at risk: a concurrent `chezmoi apply --force` (from another session, hook, or manual run) will overwrite it with the older source. Until `chezmoi add` succeeds, your edit is not durable.
- **Template files (`.tmpl`):** `chezmoi add` doesn't work — edit the source file directly (`~/.local/share/chezmoi/`) with Edit/Write tools, then `chezmoi apply --force`.
- **Always `--force` with `apply`.** Without it, chezmoi hangs waiting for a TTY that doesn't exist in agent contexts.
- **`chezmoi edit` launches `$EDITOR` — never use it from an agent.**
- **Check `chezmoi status` before editing.** If the destination shows as modified (`M`), source may be behind — sync or investigate first, don't edit blind.

## Standards

### 1. Commands

| Command                   | Direction            | When to use                                          |
| :------------------------ | :------------------- | :--------------------------------------------------- |
| `chezmoi add <dest-path>` | destination → source | After editing a plain destination file with tools    |
| `chezmoi re-add`          | destination → source | Bulk re-sync all modified plain destinations         |
| `chezmoi apply --force`   | source → destination | After editing source directly (templates/encryption) |

### 2. Workflow

```bash
# Plain files — edit destination, IMMEDIATELY sync to source (one unit, no gap)
# (use Edit/Write tools on ~/.claude/skills/my-skill/SKILL.md)
chezmoi add ~/.claude/skills/my-skill/SKILL.md

# For a multi-edit session, sync after EACH coherent edit, not at the end:
# edit A → chezmoi add A → edit B → chezmoi add B → ...
# NOT: edit A → edit B → edit C → chezmoi add (A and B at risk the whole time)

# Template files — edit source directly, deploy
# (use Edit/Write tools on ~/.local/share/chezmoi/dot_.../file.tmpl)
chezmoi apply --force

# Commit either way
git -C ~/.local/share/chezmoi add dot_claude/skills/my-skill/SKILL.md
git -C ~/.local/share/chezmoi commit -m "type(scope): msg"
git -C ~/.local/share/chezmoi push
```

### 3. Status Legend

- `M`: Modified — safe to apply
- `A`: Added in source — safe to apply
- `D`: Deleted in source — destination will be deleted
- `DA`: Conflict — deleted in source, added in destination

### 4. Skill Management

New skill: create at `~/.claude/skills/my-skill/SKILL.md` (destination), then `chezmoi add ~/.claude/skills/my-skill/SKILL.md`.

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

| Excuse                                      | Reality                                                                                                                                                                                                                                                        |
| :------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "I'll just edit the source file"            | Edit the destination file directly, then `chezmoi add <dest-path>`.                                                                                                                                                                                            |
| "I'll use `chezmoi add` on a tmpl"          | `add`/`re-add` don't work with templates. Edit source directly, then `chezmoi apply --force`.                                                                                                                                                                  |
| "I'll skip `--force`"                       | Chezmoi hangs waiting for a TTY that doesn't exist in agent contexts.                                                                                                                                                                                          |
| "I'll manually link it"                     | Manual links are lost on `apply --force`. Use source files.                                                                                                                                                                                                    |
| "I'll batch edits and `chezmoi add` later"  | Every unsynced destination edit is lost the moment another process runs `chezmoi apply --force` — another agent session, a hook, or a manual run. Sync after each coherent edit.                                                                               |
| "Destination looks unchanged, must be fine" | If your edits vanished, a `chezmoi apply --force` ran between your last edit and `chezmoi add`. Don't assume — `diff` the file against what you wrote and check `git -C ~/.local/share/chezmoi log` for recent activity from other sessions before re-editing. |
