# Dotfiles Status

## Current State

Fully synced. Fish + starship on macOS and Fedora.

## Skills — All CLIs Synced

All three CLIs share skills via symlinks from `~/.claude/skills/`:

| Skill           | Claude | Gemini | Codex | Pi  |
| --------------- | ------ | ------ | ----- | --- |
| codex           | ✓      | ✓      | ✓     | ✓   |
| creating-skills | ✓      | ✓      | ✓     | ✓   |
| prune           | ✓      | ✓      | ✓     | ✓   |
| refactor        | ✓      | ✓      | ✓     | ✓   |
| review          | ✓      | ✓      | ✓     | ✓   |
| save            | ✓      | ✓      | ✓     | ✓   |
| setup-ai        | ✓      | ✓      | ✓     | ✓   |
| sprint          | ✓      | ✓      | ✓     | ✓   |
| twitter         | ✓      | ✓      | ✓     | ✓   |
| update-chezmoi  | ✓      | ✓      | ✓     | ✓   |
| writer          | ✓      | ✓      | ✓     | ✓   |
| gemini          | ✓      | —      | —     | —   |

Pi skills path: `~/.pi/agent/skills/` (chezmoi: `dot_pi/agent/skills/`)

## Recent Changes

- Gemini model: `gemini-3.1-pro-preview`
- Starship character: `›` (matches transient prompt)
- Removed broken `ask` symlinks from Gemini, Codex, Pi (skill replaced by `twitter` + `gemini`)
- Added `twitter` and `refactor` symlinks to all three CLIs
