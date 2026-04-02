# Status

Dotfiles synced and skill paths consolidated around `~/.agents/skills`.

## Current State

- Shared skills are authored once in `dot_claude/skills/`.
- Gemini CLI, Codex CLI, Pi, Crush, and OpenCode consume the shared path cleanly.
- Antigravity is configured against the shared path on a best-effort basis, but still appears to lag Gemini CLI's Agent Skills behavior.
- No active local task remains for this skills consolidation pass.
- Global Claude guidance now explicitly prefers full refactors over shims, fallbacks, and deprecation scaffolding when a touched area is being rewritten.

## Incident (2026-03-30)

- `chezmoi apply --force` was run without reading all modified files first (llm-serve.fish, opencode.json, settings.json).
- MM status indicated conflict on `dot_pi/agent/settings.json` — resolved by apply but source/destination states not verified beforehand.
- **Lesson:** Always read all modified files before applying, especially with MM conflicts.

## Reference

- `ai/skills-sync.md` — skill matrix and chezmoi source paths for all CLIs
- `ai/shell-migration.md` — tide/starship/nushell migration notes
- `ai/research/claude-code-statusline-api.md` — statusline JSON schema and gotchas
