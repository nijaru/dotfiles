# Chezmoi Dotfiles Repository

## Quick Commands
```bash
chezmoi add <path>           # Track new dotfile
chezmoi apply --force        # Apply all changes (use --force to overwrite)
chezmoi apply --force <path> # Apply specific file
chezmoi diff                 # Preview changes
chezmoi status               # Show drift
```

## CRITICAL
- Always use `chezmoi apply --force` to overwrite and avoid prompts
- Use `~/` not `/Users/nick/` or `/home/nick/`
- Ensures cross-platform compatibility (Mac/Linux)

## Platform-Specific Files
- Suffix `_darwin` for Mac-only (e.g., `Brewfile_darwin`)
- Suffix `_linux` for Linux-only
- chezmoi auto-applies based on OS

## Project Structure
- `dot_config/` → `~/.config/`
- `dot_claude/` → `~/.claude/`
- `private_dot_ssh/` → `~/.ssh/` (encrypted)
- `run_once_*` → One-time setup scripts
- `.chezmoiignore` → Files excluded from apply

## Naming Convention
- `dot_*` → `~/.*`
- `dot_config/<app>` → `~/.config/<app>`
- `private_*` → Encrypted sensitive files

## Files to Exclude
- Runtime: `fish_variables`, cache, session data
- Secrets: API keys, tokens (use `~/.config/fish/secrets.fish` - NOT tracked)
- Templates: Use `.tmpl`, keep logic minimal

## Testing
```bash
chezmoi apply --dry-run --verbose   # Simulate
chezmoi apply --force                # Apply (use --force to overwrite)
chezmoi doctor                       # Verify environment
```

Fish: Open new session, test commands
Performance: `hyperfine -w 3 'fish -lc exit'`

## Cross-Machine Sync
Mac: `nick@apple`, Fedora: `nick@fedora`

```bash
ssh nick@fedora 'fish -l -i -c "chezmoi update && chezmoi apply --force"'
```

## Security
- Never commit secrets in plaintext
- Use `private_*` for sensitive files
- Verify `private_dot_ssh` permissions after apply
