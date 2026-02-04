---
name: update-chezmoi
description: Use when modifying global CLAUDE.md, dotfiles, or chezmoi config; syncing skills across machines; or adding skills to multiple TUI agents
---

# Update Chezmoi

Manage global Claude/Codex config and skills via chezmoi dotfiles.

## Architecture

| Tool        | Deployed       | Chezmoi Source       | Notes           |
| ----------- | -------------- | -------------------- | --------------- |
| Claude Code | `~/.claude/`   | `dot_claude/`        | Source of truth |
| Codex CLI   | `~/.codex/`    | `private_dot_codex/` | Encrypted       |
| Gemini CLI  | `~/.gemini/`   | `dot_gemini/`        |                 |
| pi-mono     | `~/.pi/agent/` | `dot_pi/agent/`      |                 |

**Single source of truth:** `dot_claude/CLAUDE.md` → all agents symlink AGENTS.md to it

## Common Operations

### Update Global CLAUDE.md

```bash
# Edit directly (chezmoi tracks ~/.claude/)
$EDITOR ~/.claude/CLAUDE.md

# Verify and apply
chezmoi diff
chezmoi apply
```

### Add New Skill

1. Create skill directory:

```bash
mkdir -p ~/.claude/skills/my-skill
```

2. Create SKILL.md (see creating-skills skill for format)

3. Share with other agents via symlinks:

```bash
# Codex CLI
echo "/Users/nick/.claude/skills/my-skill" > \
  ~/.local/share/chezmoi/private_dot_codex/skills/symlink_my-skill

# pi-mono
echo "/Users/nick/.claude/skills/my-skill" > \
  ~/.local/share/chezmoi/dot_pi/agent/skills/symlink_my-skill
```

4. Apply:

```bash
chezmoi apply
```

### Update Existing Skill

```bash
# Edit in deployed location (chezmoi source auto-updates)
$EDITOR ~/.claude/skills/my-skill/SKILL.md
```

### Sync to Other Machines

```bash
# On source machine
cd ~/.local/share/chezmoi && git add -A && git commit -m "Update claude config" && git push

# On target machine
chezmoi update
```

## Chezmoi Symlink Pattern

Files named `symlink_TARGET` in chezmoi source become symlinks:

- File: `private_dot_codex/skills/symlink_profile`
- Content: `/Users/nick/.claude/skills/profile`
- Result: `~/.codex/skills/profile` → `/Users/nick/.claude/skills/profile`

## File Locations

| File            | Chezmoi Source                        | Deployed                       |
| --------------- | ------------------------------------- | ------------------------------ |
| CLAUDE.md       | `dot_claude/CLAUDE.md`                | `~/.claude/CLAUDE.md`          |
| Skills          | `dot_claude/skills/*/`                | `~/.claude/skills/*/`          |
| Codex config    | `private_dot_codex/config.toml`       | `~/.codex/config.toml`         |
| Codex AGENTS.md | `private_dot_codex/symlink_AGENTS.md` | `~/.codex/AGENTS.md` (symlink) |

## Verification

```bash
# Check chezmoi status
chezmoi status

# Preview changes
chezmoi diff

# Verify symlinks
ls -la ~/.codex/AGENTS.md
ls -la ~/.codex/skills/
```
