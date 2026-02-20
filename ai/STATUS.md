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

## Possible Future Work

- **Tide**: Still installed via fisher (`dot_config/fish/functions/tide/`). Starship overrides it via `config.fish`. Switch back = remove `starship init fish | source` + `enable_transience`, re-run `tide configure`.
- **Nushell**: Migration started but not completed. Blockers were secrets template and SSH agent. Fish functions (up, ghc, update-agents, etc.) would need porting.

## Recent Changes

- Gemini model: `gemini-3.1-pro-preview`
- Starship character: `›` (matches transient prompt)
- Removed broken `ask` symlinks from Gemini, Codex, Pi (skill replaced by `twitter` + `gemini`)
- Added `twitter` and `refactor` symlinks to all three CLIs
