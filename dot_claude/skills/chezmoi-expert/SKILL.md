---
name: chezmoi-expert
description: Use for managing dotfiles, syncing agent skills/config, and handling chezmoi source/destination workflows.
allowed-tools: Bash, Read, Write, Edit
---

# chezmoi

## 🎯 Mandates

- **Edit source, not destination.** Source is `~/.local/share/chezmoi/` (`dot_` prefix maps to `~/`). Never edit `~/` files directly.
- **`chezmoi apply --force` after every change.** Always `--force` — without it, chezmoi prompts interactively and hangs in non-TTY contexts (agents, scripts).
- **`chezmoi status` before applying** if the diff is unexpected. `chezmoi diff` to inspect before committing.

## 🛠️ Standards

### 1. add vs apply — critical distinction

| Command                   | Direction            | When to use                                                     |
| :------------------------ | :------------------- | :-------------------------------------------------------------- |
| `chezmoi add <dest-path>` | destination → source | Sync destination changes back to source (new or existing files) |
| `chezmoi apply --force`   | source → destination | Deploy source changes to the live system                        |

**Never use `chezmoi add` to deploy.** It overwrites source with destination.

### 2. Workflow

```bash
# Edit source
edit ~/.local/share/chezmoi/dot_claude/skills/my-skill/SKILL.md

# Deploy + commit
chezmoi apply --force
cd ~/.local/share/chezmoi
git add <specific-file>          # never git add . or git add -p
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

## 🚫 Anti-Rationalization

| Excuse                             | Reality                                                               |
| :--------------------------------- | :-------------------------------------------------------------------- |
| "I'll use `chezmoi add` to deploy" | `add` goes destination → source. Use `apply --force`.                 |
| "I'll skip `--force`"              | Chezmoi hangs waiting for a TTY that doesn't exist in agent contexts. |
| "I'll apply later"                 | Drift causes silent config bugs. Apply immediately.                   |
| "I'll manually link it"            | Manual links are lost on `apply --force`. Use source files.           |
