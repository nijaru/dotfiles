# Status

## Current Focus

- Qwen3.6 27B serving research: stable default is stock llama.cpp with Unsloth `UD-Q4_K_XL` at 262k context; `Q5_K_M` fits idle but crashed on long Pi prompts; see `ai/research/qwen36-27b-4090-serving.md`.
- DeepSeek v4 Flash GGUF via antirez is recorded as a watch item only; do not replace Fedora Qwen unless CUDA support, quant details, and coding-agent quality/perf are verified.
- Latest vLLM/TurboQuant 3090 report is recorded as an experiment path, not a default replacement: patched vLLM can be faster at lower context, but the corrected single-card path trades away the current 262k llama.cpp shape. llama.cpp speculative decoding with `Qwen3-0.6B-Q8_0` draft was tested and was slower than baseline.
- VCS agent skills tightened: `jj` and GitButler CLI (`but`) source and destination are in sync.
- Local agent configs now target Fedora llama.cpp Qwen3.6 27B on `http://fedora:8080/v1`.
- Ollama providers are retired from Pi, OpenCode, Droid/Factory, Crush, and Zed managed configs.
- Zed uses `agent.default_model` plus `language_models.openai_compatible.fedora` for the custom endpoint.
- `llm-serve` is a fish/Nushell function wrapping `hf download` + `llama-server`; bare `llm-serve` prints help. `--unc` selects the HauhauCS Aggressive uncensored Qwen secondary model, reusing default port `8080`. Plain `llm-serve stop` stops both regular and uncensored Qwen variants.

Skills sync fully simplified. Skill updates stay in chezmoi source under `dot_claude/skills/`, then apply via chezmoi after review.
Save skill clarified: agents should persist only to existing `ai/`/`tk` surfaces, avoid initializing new systems during save, and avoid commits purely because the skill ran.

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
