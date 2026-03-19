# Skills Sync

All CLIs share skills via symlinks from `~/.claude/skills/`. Managed by chezmoi.

| Skill                    | Claude | Gemini | Codex | Pi  | Crush |
| ------------------------ | ------ | ------ | ----- | --- | ----- |
| autoresearch             | ✓      | ✓      | ✓     | ✓   | ✓     |
| codex                    | ✓      | ✓      | ✓     | ✓   | ✓     |
| creating-skills          | ✓      | ✓      | ✓     | ✓   | ✓     |
| gemini                   | ✓      | —      | —     | —   | ✓     |
| github-actions-workflows | ✓      | ✓      | ✓     | ✓   | ✓     |
| prune                    | ✓      | ✓      | ✓     | ✓   | ✓     |
| refactor                 | ✓      | ✓      | ✓     | ✓   | ✓     |
| review                   | ✓      | ✓      | ✓     | ✓   | ✓     |
| save                     | ✓      | ✓      | ✓     | ✓   | ✓     |
| setup-ai                 | ✓      | ✓      | ✓     | ✓   | ✓     |
| sprint                   | ✓      | ✓      | ✓     | ✓   | ✓     |
| twitter                  | ✓      | ✓      | ✓     | ✓   | ✓     |
| update-chezmoi           | ✓      | ✓      | ✓     | ✓   | ✓     |
| writer                   | ✓      | ✓      | ✓     | ✓   | ✓     |

## Chezmoi source paths

| CLI    | Skills path               | Chezmoi source                       |
| ------ | ------------------------- | ------------------------------------ |
| Claude | `~/.claude/skills/`       | `dot_claude/skills/` (canonical)     |
| Gemini | `~/.gemini/skills/`       | `dot_gemini/skills/symlink_*`        |
| Codex  | `~/.codex/skills/`        | `private_dot_codex/skills/symlink_*` |
| Pi     | `~/.pi/agent/skills/`     | `dot_pi/agent/skills/symlink_*`      |
| Crush  | `~/.config/crush/skills/` | `dot_config/crush/skills/symlink_*`  |

To add a skill: create it in `~/.claude/skills/`, then add a `symlink_<name>` file containing the absolute path to each CLI's chezmoi source dir, then `chezmoi apply`.

Gemini CLI follows the Agent Skills standard: user skills live in `~/.gemini/skills/`, with `~/.agents/skills/` as a higher-priority alias. `dot_gemini/antigravity/skills/` is not part of the current sync path.
