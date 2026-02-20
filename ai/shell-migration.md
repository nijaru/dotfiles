# Shell Migration Notes

## Current: Fish + Starship

Fish is the default shell. Starship handles the prompt with `enable_transience` in `config.fish`.
Tide is still installed via fisher (`dot_config/fish/functions/tide/`) but overridden by starship.

## Switching back to Tide

Remove from `config.fish`:

```fish
starship init fish | source
enable_transience
```

Then run `tide configure`.

## Nushell migration (incomplete)

Started but not finished. Nushell is set up with starship, carapace, zoxide, and aliases.

**Blockers:**

| Component       | Fish source                    | Notes                                 |
| --------------- | ------------------------------ | ------------------------------------- |
| Secrets         | `secrets.fish.tmpl`            | Chezmoi template — main blocker       |
| SSH agent       | `darwin.fish`                  | launchd socket + keychain unlock      |
| direnv          | `dev.fish`                     | `direnv hook fish`                    |
| OrbStack        | `config.fish`                  | `source ~/.orbstack/shell/init2.fish` |
| `up`            | `functions/up.fish`            | System update function                |
| `ghc`           | `functions/ghc.fish`           | Clone to `~/github/org/repo`          |
| `update-agents` | `functions/update-agents.fish` | Batch AI agent config updates         |
| Docker fns      | `functions/docker/`            | dksh, dklogs, dkclean, etc.           |
| Modern CLI      | `functions/modern-cli/`        | eza, rg, delta wrappers               |
| `/etc/shells`   | —                              | Register nushell as login shell       |
