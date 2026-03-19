# Skills Sync

Canonical shared skills live in `~/.claude/skills/`, with `~/.agents/skills/` as the shared cross-tool path. Managed by chezmoi.

| Skill                    | Claude | Gemini | Codex | Pi  | Crush | Antigravity |
| ------------------------ | ------ | ------ | ----- | --- | ----- | ----------- |
| autoresearch             | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| codex                    | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| creating-skills          | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| github-actions-workflows | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| prune                    | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| refactor                 | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| research                 | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| review                   | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| save                     | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| setup-ai                 | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| sprint                   | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| twitter                  | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| update-chezmoi           | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |
| writer                   | ✓      | ✓      | ✓     | ✓   | ✓     | ✓           |

Tool-specific skills remain outside the shared set:

- `gemini` stays Gemini/Claude/Crush-facing.
- Codex system skills remain under `~/.codex/skills/.system`.
- Any future Pi, Crush, or Gemini-only skills should stay in the tool-local root.

## Path Strategy

| Tool | Shared skills strategy | Tool-specific location |
| ---- | ---------------------- | ---------------------- |
| Claude Code | native `~/.claude/skills/` | `dot_claude/skills/` |
| Gemini CLI | native `~/.agents/skills/` alias | `dot_gemini/skills/` for Gemini-only skills |
| Codex CLI | native `~/.agents/skills` discovery | `private_dot_codex/skills/` only for Codex-only extras if ever needed |
| Pi | `dot_pi/agent/settings.json -> skills: ["~/.agents/skills"]` | `dot_pi/agent/skills/` for Pi-only skills |
| Crush | `dot_config/crush/crush.json -> options.skills_paths` includes `~/.agents/skills` | `dot_config/crush/skills/` for Crush-only skills |
| OpenCode | native shared discovery via `~/.agents/skills` | `dot_config/opencode/skills/` only if ever needed |
| Antigravity | `~/.gemini/antigravity/skills -> ~/.agents/skills` | `dot_gemini/antigravity/` |

## Strategy

- Author shared skills once in `dot_claude/skills/`.
- Let Gemini CLI discover shared skills through `~/.agents/skills`; keep `dot_gemini/skills/` only for Gemini-specific skills.
- Let Pi discover shared skills through `~/.agents/skills` via `settings.json`; keep `dot_pi/agent/skills/` only for Pi-specific skills.
- Let Crush discover shared skills through `options.skills_paths`; keep `dot_config/crush/skills/` only for Crush-specific skills.
- Let OpenCode discover shared skills through `~/.agents/skills`; do not mirror shared skills into `~/.config/opencode/skills/`.
- Let Codex discover shared skills through `~/.agents/skills`; do not mirror shared skills into `~/.codex/skills/`.
- Point Antigravity's legacy `skills` root directly at `~/.agents/skills`, and treat `skills.txt` as a consistency hint rather than the primary discovery mechanism.

## Notes

- Gemini CLI follows the Agent Skills standard: user skills live in `~/.gemini/skills/`, with `~/.agents/skills/` as a higher-priority alias.
- Codex officially reads user skills from `~/.agents/skills`, repo skills from `.agents/skills` up to repo root, and supports symlinked skill folders in those locations.
- OpenCode loads skills from `~/.config/opencode/skills/`, `~/.claude/skills/`, and `~/.agents/skills/`. Set `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1` to avoid duplicate discovery when `~/.agents` aliases `~/.claude`.
- Pi natively discovers both `~/.pi/agent/skills/` and `~/.agents/skills/`, so the explicit `skills` setting is a clear, portable way to make the shared root obvious in config.
- Antigravity currently stores a GUI-configured custom path in `~/.gemini/antigravity/skills.txt`, but direct linkage of its legacy `skills` directory is the more reliable arrangement.
- As of March 18, 2026, Antigravity still does not appear to surface these shared skills reliably even with the direct link, so treat its setup as best-effort until its loader catches up with Gemini CLI.
