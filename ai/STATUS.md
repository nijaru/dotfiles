# Dotfiles Status

## Nushell Migration

Nushell is set up as a usable shell with starship, carapace, zoxide, aliases, and transient prompt. Fish and nushell both use starship now (Tide disabled, config saved in `ai/tide-config-backup.txt`).

### Remaining to migrate for daily driver use

| Component           | Fish source                      | Notes                                                |
| ------------------- | -------------------------------- | ---------------------------------------------------- |
| Secrets             | `secrets.fish.tmpl`              | Chezmoi template with API keys — **blocker**         |
| SSH agent (macOS)   | `darwin.fish`                    | launchd socket lookup, keychain unlock — **blocker** |
| direnv              | `dev.fish`                       | `direnv hook fish`, nushell support exists           |
| OrbStack            | `config.fish`                    | `source ~/.orbstack/shell/init2.fish`                |
| `up`                | `functions/up.fish`              | System update (brew, mise, git, etc.)                |
| `ghc`               | `functions/ghc.fish`             | Clone to `~/github/org/repo`                         |
| `update-agents`     | `functions/update-agents.fish`   | Batch update AI agent configs via bun                |
| `brewfile-update`   | `functions/brewfile-update.fish` | Sync Brewfile                                        |
| `llm-serve`         | `functions/llm-serve.fish`       | Serve LLM models                                     |
| Docker functions    | `functions/docker/`              | dksh, dklogs, dkclean, dkstats, dkprune              |
| Modern CLI wrappers | `functions/modern-cli/`          | eza, rg, delta, etc.                                 |
| `/etc/shells`       | —                                | Register nushell as login shell                      |

### Fedora-specific

Starship and carapace installed via `dnf install starship carapace`.
