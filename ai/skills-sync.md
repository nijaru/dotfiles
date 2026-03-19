# Skills Sync

Canonical shared skills live in `~/.claude/skills/`, with `~/.agents/skills/` as the shared cross-tool path. Managed by chezmoi.

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

## Path Strategy

| Tool | Shared skills strategy | Tool-specific location |
| ---- | ---------------------- | ---------------------- |
| Claude Code | native `~/.claude/skills/` | `dot_claude/skills/` |
| Gemini CLI | native `~/.agents/skills/` alias | `dot_gemini/skills/` for Gemini-only skills |
| Codex CLI | mirrored into `~/.codex/skills/` | `private_dot_codex/skills/` |
| Pi | `dot_pi/agent/settings.json -> skills: ["~/.agents/skills"]` | `dot_pi/agent/skills/` for Pi-only skills |
| Crush | `dot_config/crush/crush.json -> options.skills_paths` includes `~/.agents/skills` | `dot_config/crush/skills/` for Crush-only skills |
| OpenCode | native shared discovery via `~/.agents/skills` | `dot_config/opencode/skills/` only if ever needed |
| Antigravity | bridge shared skills into its legacy root | `dot_gemini/antigravity/skills/` |

## Strategy

- Author shared skills once in `dot_claude/skills/`.
- Let Gemini CLI discover shared skills through `~/.agents/skills`; keep `dot_gemini/skills/` only for Gemini-specific skills.
- Let Pi discover shared skills through `~/.agents/skills` via `settings.json`; keep `dot_pi/agent/skills/` only for Pi-specific skills.
- Let Crush discover shared skills through `options.skills_paths`; keep `dot_config/crush/skills/` only for Crush-specific skills.
- Let OpenCode discover shared skills through `~/.agents/skills`; do not mirror shared skills into `~/.config/opencode/skills/`.
- Mirror into Codex only while its shared-path configuration remains unverified.
- Bridge Antigravity's legacy path back to the shared skills directory instead of relying on the GUI custom path alone.

## Notes

- Gemini CLI follows the Agent Skills standard: user skills live in `~/.gemini/skills/`, with `~/.agents/skills/` as a higher-priority alias.
- OpenCode loads skills from `~/.config/opencode/skills/`, `~/.claude/skills/`, and `~/.agents/skills/`. Set `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1` to avoid duplicate discovery when `~/.agents` aliases `~/.claude`.
- Antigravity currently has a GUI-configured custom path in `~/.gemini/antigravity/skills.txt`, but that path does not appear to be sufficient on its own.
