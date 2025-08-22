# Repository Guidelines

## Project Structure & Module Organization
- `dot_config/`: Per‑app configs (e.g., `fish/`, `ghostty/`, `zed/`).
- `dot_gitconfig.tmpl`, `dot_gitignore`: Global Git setup (templated when needed).
- `private_dot_ssh/`: Sensitive SSH config; managed by chezmoi, not for plaintext secrets.
- `run_once_*`: One‑time setup scripts (e.g., `run_once_setup-tide.fish.tmpl`).
- `.chezmoiignore`: Paths excluded from apply to `$HOME`.
- `.claude/`: Local assistant settings relevant to this repo.

## Build, Test, and Development Commands
- `chezmoi status`: Show drift between repo and `$HOME`.
- `chezmoi diff`: Preview changes that would be applied.
- `chezmoi apply --dry-run --verbose`: Simulate apply to verify effects safely.
- `chezmoi apply`: Apply changes to your home directory.
- `chezmoi cd`: Open the working tree for direct edits.

## Coding Style & Naming Conventions
- **ChezMoi names**: `dot_*` → `~/.*`; `dot_config/<app>` → `~/.config/<app>`.
- **Templates**: Use `*.tmpl`; keep logic minimal and data‑driven.
- **Shell**: Prefer POSIX sh or Fish; 2‑space indent; snake_case for functions/aliases.
- **Secrets**: Store in `private_*` or template data, never in tracked plaintext files.

## Testing Guidelines
- Run `chezmoi apply --dry-run` then `chezmoi apply` to validate changes.
- For Fish functions/aliases, open a new session and smoke‑test key commands.
- Use `chezmoi doctor` to verify environment prerequisites.
- Measure Fish startup performance: `hyperfine -w 3 'fish -lc exit'`
- Test lazy-loading: Type `dev` or cd to a project directory

## Commit & Pull Request Guidelines
- **Messages**: Imperative mood (e.g., “Add”, “Update”); include path scope when helpful (e.g., `Update .config/zed/settings.json`).
- **Scope**: Keep commits focused; explain rationale for non‑obvious changes.
- **PRs**: Include summary, affected apps/paths, screenshots for UI changes (Ghostty/Zed), and link issues when applicable.

## Security & Configuration Tips
- Do not commit secrets; rely on `private_*` and `.chezmoiignore`.
- Review diffs before first apply on a new machine; confirm `private_dot_ssh` permissions after apply.

