# Skills Sync

All CLIs share skills via symlinks from `~/.claude/skills/`. Managed by chezmoi.

| Skill           | Claude | Gemini | Codex | Pi  |
| --------------- | ------ | ------ | ----- | --- |
| codex           | ✓      | ✓      | ✓     | ✓   |
| creating-skills | ✓      | ✓      | ✓     | ✓   |
| gemini          | ✓      | —      | —     | —   |
| prune           | ✓      | ✓      | ✓     | ✓   |
| refactor        | ✓      | ✓      | ✓     | ✓   |
| review          | ✓      | ✓      | ✓     | ✓   |
| save            | ✓      | ✓      | ✓     | ✓   |
| setup-ai        | ✓      | ✓      | ✓     | ✓   |
| sprint          | ✓      | ✓      | ✓     | ✓   |
| twitter         | ✓      | ✓      | ✓     | ✓   |
| update-chezmoi  | ✓      | ✓      | ✓     | ✓   |
| writer          | ✓      | ✓      | ✓     | ✓   |

## Chezmoi source paths

| CLI    | Skills path           | Chezmoi source                       |
| ------ | --------------------- | ------------------------------------ |
| Claude | `~/.claude/skills/`   | `dot_claude/skills/` (canonical)     |
| Gemini | `~/.gemini/skills/`   | `dot_gemini/skills/symlink_*`        |
| Codex  | `~/.codex/skills/`    | `private_dot_codex/skills/symlink_*` |
| Pi     | `~/.pi/agent/skills/` | `dot_pi/agent/skills/symlink_*`      |

To add a skill: create it in `~/.claude/skills/`, then add a `symlink_<name>` file containing the absolute path to each CLI's chezmoi source dir, then `chezmoi apply`.
