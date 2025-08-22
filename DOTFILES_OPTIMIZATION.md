# Dotfiles Optimization Plan

This note captures findings and a minimal, actionable plan to improve Fish startup time, manage Tide via Fisher, and replace fragile abbreviations with smart aliases. It avoids changes to your Git config and keeps `mise` using `@latest`.

## Findings (Context)
- Chezmoi layout is solid; Fish config lives in `dot_config/fish/` with `conf.d/` autoload and function subdirs.
- Tide is configured via `_tide_init.fish` in `conf.d/` (vendored init). Fisher is not yet the source of truth for plugins.
- Several abbreviations map to non-default tools (`delta`, `btop`, `duf`, `dust`, `procs`, `doggo`, `gping`). If a tool is missing, the abbr expands to a broken command.
- Completions are initialized in `completions.fish`; `kubectl` completion generation runs at startup when present.

## Proposed Changes (Minimal + High-Impact)
1) Fisher-manage Tide (keep Tide, drop Starship)
- Add `dot_config/fish/fish_plugins` with: `ilancosman/tide@v6` and (optional) `PatrickF1/fzf.fish`.
- Remove/disable vendored `_tide_init.fish` so Tide loads via Fisher (faster, cleaner upgrades).
- Install/update with: `fisher update` (from an interactive Fish session).

2) Faster Fish startup
- Gate heavy init to interactive shells: wrap `completions.fish` blocks with `if status is-interactive`.
- Move one-time `kubectl` completion generation to a `run_once_generate-kubectl-completions.fish.tmpl` script.
- Keep `mise` activation but only in interactive sessions.

3) Smart aliases instead of brittle abbreviations
- Add functions under `dot_config/fish/functions/modern-cli/` that fall back to system tools when modern tools are missing:
  - `diff` → use `delta` if available, else `command diff`.
  - `top` → `btop` else `top`; `df` → `duf` else `df`; `du` → `dust` else `du`; `ps` → `procs` else `ps`; `dig` → `doggo` else `dig`; `ping` → `gping` else `ping`.
- Keep or simplify related abbreviations; prefer function-based fallbacks for reliability.

## Implementation Steps
- Create `dot_config/fish/fish_plugins` with plugins (Tide required, fzf.fish optional).
- Delete or rename `dot_config/fish/conf.d/_tide_init.fish` so Fisher controls Tide.
- Update `dot_config/fish/conf.d/completions.fish`:
  - Wrap with `if status is-interactive; ...; end`.
  - Remove in-session kubectl generation; create `run_once_generate-kubectl-completions.fish.tmpl` to write `~/.config/fish/completions/kubectl.fish` when `kubectl` exists.
- Add fallback functions in `functions/modern-cli/` for the tools listed above.

## Verify & Measure
- Preview/apply: `chezmoi diff` → `chezmoi apply --dry-run` → `chezmoi apply`.
- Measure startup (before/after): `hyperfine -w 3 'fish -lc exit'`.
- Confirm Tide loads and `git_abbr` still works; test each smart alias with and without modern tools installed.

## Constraints Honored
- Keep Tide (preferred) and do not change Git config semantics.
- Avoid over-engineering; only the changes above.
- `mise` remains `@latest`.
