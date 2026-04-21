---
date: 2026-04-09
summary: How agent skills are shared across all CLI tools
status: active
---

# Skills Sync

## Architecture

Canonical skills live in `~/.claude/skills/`. Everything else flows from there.

```
~/.claude/skills/   ← canonical source, managed by chezmoi
~/.agents/          ← symlink → ~/.claude  (chezmoi: symlink_dot_agents)
~/.agents/skills/   ← therefore also ~/.claude/skills/
```

## Tool Discovery

Every tool reads `~/.agents/skills/` natively — no sync scripts, no symlinks to maintain.

| Tool        | Skills path         | How configured                      |
| :---------- | :------------------ | :---------------------------------- |
| Claude Code | `~/.claude/skills/` | Hardcoded (canonical)               |
| Codex CLI   | `~/.agents/skills/` | Hardcoded                           |
| Goose       | `~/.agents/skills/` | Hardcoded                           |
| Opencode    | `~/.agents/skills/` | `opencode.json → skills.paths`      |
| Crush       | `~/.agents/skills/` | `crush.json → options.skills_paths` |
| Pi          | `~/.agents/skills/` | `settings.json → skills`            |

## Adding a Skill

1. Create `~/.claude/skills/<name>/SKILL.md`
2. `chezmoi add ~/.claude/skills/<name>/SKILL.md`
3. Done — all tools pick it up immediately via the `~/.agents` symlink

## Tool-Specific Extras

- **Codex** — `~/.codex/skills/.system/` contains Codex-managed built-in skills (imagegen, skill-creator, etc.). Do not touch.
- **Crush** — `crush.json` also lists `~/.config/crush/skills/` as a secondary path for Crush-only skills if ever needed.
- **Pi** — `~/.pi/agent/skills/` exists as a secondary path for Pi-only skills if ever needed.

## History

Previously used a `run_onchange_sync-agent-skills.sh.tmpl` chezmoi script to maintain explicit skill symlinks per tool. Removed 2026-04-09 after confirming all tools read `~/.agents/skills/` natively.
