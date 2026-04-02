---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent skills/config, and handling chezmoi source/destination workflows.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi

## Mandates

- **Prefer `chezmoi edit --apply $FILE`** — opens the source file directly, applies on exit. Works with templates and encrypted files.
- **Alternative: edit destination, then `chezmoi add $FILE`** — valid for plain (non-template) files. Simpler when editing many files at once.
- **`chezmoi add` does NOT work with templates** (`.tmpl` files) — use `chezmoi edit` for those.
- **Always `--force` with `apply`.** Without it, chezmoi prompts interactively and hangs in non-TTY contexts.

## Standards

### 1. Commands

| Command                      | Direction            | When to use                                            |
| :--------------------------- | :------------------- | :----------------------------------------------------- |
| `chezmoi edit --apply $FILE` | source (opens+apply) | Primary workflow — works for all file types            |
| `chezmoi add <dest-path>`    | destination → source | After editing destination directly (non-templates)     |
| `chezmoi re-add`             | destination → source | Bulk re-sync all modified destinations (non-templates) |
| `chezmoi apply --force`      | source → destination | Pulling updates from remote, deploying source changes  |

### 2. Workflow

```bash
# Option A — recommended (works with templates/encryption)
chezmoi edit --apply ~/.claude/skills/my-skill/SKILL.md

# Option B — destination-first (plain files only)
edit ~/.claude/skills/my-skill/SKILL.md
chezmoi add ~/.claude/skills/my-skill/SKILL.md

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
