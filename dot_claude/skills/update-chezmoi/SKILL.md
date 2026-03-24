---
name: update-chezmoi
description: Use when modifying dotfiles, global AI config (~/.claude/CLAUDE.md), or syncing skills across agents.
allowed-tools: Read, Write, Edit, Bash
---

# Update Chezmoi

Manage global agent configurations and skills through the `chezmoi` dotfiles system.

## 🎯 Mandates

- **Source of Truth:** Edit files in the chezmoi source (`~/.local/share/chezmoi/`), not the destination (`~/`).
- **Apply after every change:** Run `chezmoi apply --force` immediately after modifying source files.
- **Sync:** Commit and push to remote after verifying local changes.

## 🛠️ Standards

### 1. add vs apply — critical distinction

| Command                   | Direction            | When to use                                          |
| :------------------------ | :------------------- | :--------------------------------------------------- |
| `chezmoi add <dest-path>` | destination → source | Pull a file INTO chezmoi tracking for the first time |
| `chezmoi apply --force`   | source → destination | Deploy source changes to the live system             |

**Never use `chezmoi add` to deploy.** It goes the wrong direction and overwrites source with destination.

**Always use `--force`** when running `chezmoi apply` from a non-TTY context (scripts, agents). Without it, chezmoi prompts interactively on any drift and hangs without a terminal.

### 2. Workflow

Edit source files directly in `$(chezmoi source-path)` (i.e. `~/.local/share/chezmoi/`), then:

```bash
chezmoi apply --force          # deploy to destination
cd $(chezmoi source-path)
git add <specific-file>        # never git add . or git add -p
git commit -m "type(scope): msg"
git push
```

### 3. Skill Management

To add a global skill:

1. Create the skill file under `$(chezmoi source-path)/dot_claude/skills/my-skill/SKILL.md`.
2. Run `chezmoi apply --force` to deploy it to `~/.claude/skills/`.
3. Shared-capable tools consume via `~/.agents/skills`.

### 4. Symlink Pattern

Files named `symlink_NAME` in the source directory automatically resolve to symlinks in the target location.

Current preference:

- Shared path: `~/.agents/skills` (alias of `~/.claude/skills`)
- Codex: use the shared path directly
- Gemini CLI: use the shared path for shared skills
- Pi: add the shared path in `~/.pi/agent/settings.json`
- Crush: add the shared path in `~/.config/crush/crush.json`
- OpenCode: use the shared path and disable duplicate `.claude/skills` scanning
- Antigravity: point `~/.gemini/antigravity/skills` at the shared path

### 3. Symlink Pattern

Files named `symlink_NAME` in the source directory automatically resolve to symlinks in the target location.

Current preference:

- Shared path: `~/.agents/skills` (alias of `~/.claude/skills`)
- Codex: use the shared path directly
- Gemini CLI: use the shared path for shared skills
- Pi: add the shared path in `~/.pi/agent/settings.json`
- Crush: add the shared path in `~/.config/crush/crush.json`
- OpenCode: use the shared path and disable duplicate `.claude/skills` scanning
- Antigravity: point `~/.gemini/antigravity/skills` at the shared path

## 🚫 Anti-Rationalization

| Excuse                             | Reality                                                             |
| :--------------------------------- | :------------------------------------------------------------------ |
| "I'll use `chezmoi add` to deploy" | `add` goes destination → source. Use `apply --force` to deploy.     |
| "I'll apply later"                 | Drift between source and destination causes silent config bugs.     |
| "I'll skip `--force`"              | Without it, chezmoi hangs waiting for a TTY that doesn't exist.     |
| "I'll manually link it"            | Manual links are lost on `chezmoi apply --force`. Use source files. |
