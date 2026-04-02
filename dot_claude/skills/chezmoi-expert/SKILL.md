---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent skills/config, and handling chezmoi source/destination workflows.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi

## Mandates

- **Edit destination, then `chezmoi add`.** Edit the live file at `~/`, then run `chezmoi add <dest-path>` to sync back to source. Fewer steps, no double-writing.
- **Always `--force` with `apply`.** Without it, chezmoi prompts interactively and hangs in non-TTY contexts.
- **`chezmoi diff` before committing** if the diff is unexpected.

## Standards

### 1. add vs apply — critical distinction

| Command                   | Direction            | When to use                                       |
| :------------------------ | :------------------- | :------------------------------------------------ |
| `chezmoi add <dest-path>` | destination → source | After editing a destination file directly         |
| `chezmoi apply --force`   | source → destination | Pulling updates — deploying source to live system |

### 2. Workflow

```bash
# Edit destination directly
edit ~/.claude/skills/my-skill/SKILL.md

# Sync to source + commit
chezmoi add ~/.claude/skills/my-skill/SKILL.md
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

| Excuse                               | Reality                                                               |
| :----------------------------------- | :-------------------------------------------------------------------- |
| "I'll edit the source file directly" | Edit destination, then `chezmoi add`. Fewer steps, no double-writing. |
| "I'll skip `--force`"                | Chezmoi hangs waiting for a TTY that doesn't exist in agent contexts. |
| "I'll `chezmoi add` after apply"     | `add` first, then commit. `apply` is for pulling updates only.        |
| "I'll manually link it"              | Manual links are lost on `apply --force`. Use source files.           |
