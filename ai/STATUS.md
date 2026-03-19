# Status

Dotfiles synced and skill paths consolidated around `~/.agents/skills`.

## Current State

- Shared skills are authored once in `dot_claude/skills/`.
- Gemini CLI, Codex CLI, Pi, Crush, and OpenCode consume the shared path cleanly.
- Antigravity is configured against the shared path on a best-effort basis, but still appears to lag Gemini CLI's Agent Skills behavior.
- No active local task remains for this skills consolidation pass.

## Reference

- `ai/skills-sync.md` — skill matrix and chezmoi source paths for all CLIs
- `ai/shell-migration.md` — tide/starship/nushell migration notes
- `ai/research/claude-code-statusline-api.md` — statusline JSON schema and gotchas
