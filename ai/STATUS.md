# Status

## Current Focus

- Local agent configs now target Fedora llama.cpp Qwen3.6 27B on `http://fedora:8080/v1`.
- Ollama providers are retired from Pi, OpenCode, Droid/Factory, Crush, and Zed managed configs.
- Zed uses `agent.default_model` plus `language_models.openai_compatible.fedora` for the custom endpoint.
- `llm-serve` is a `uv` Python executable with Fish/Nushell shims; bare `llm-serve` prints help.

Skills sync fully simplified. Chezmoi state clean.

## Current State

- All skills authored in `~/.claude/skills/`, accessible to all tools via `~/.agents` symlink.
- No sync scripts. No per-tool symlink maintenance. All tools read `~/.agents/skills/` natively.
- `run_onchange_sync-agent-skills.sh.tmpl` removed 2026-04-09 — was unnecessary.
- `skills-config.yaml` retained as documentation only (no longer drives any script logic).
- New skills added today: `cpp-expert`, `cmake-expert`, `juce-expert`, `ai-context`.
- Global CLAUDE.md: `ai/` section trimmed from 60 lines to ~20; full conventions moved to `ai-context` skill.

## Incident (2026-03-30)

- `chezmoi apply --force` run without reading all modified files first.
- MM conflict on `dot_pi/agent/settings.json` — resolved by apply but not verified beforehand.
- **Lesson:** Always `chezmoi diff` before apply, especially with MM conflicts.

## Reference

- `ai/skills-sync.md` — skill path architecture and tool discovery table
- `ai/shell-migration.md` — tide/starship/nushell migration notes
- `ai/research/claude-code-statusline-api.md` — statusline JSON schema and gotchas
- `ai/ollama-setup.md` — stale Ollama setup notes, retained only as migration history
