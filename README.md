# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell**: Fish shell with [Tide](https://github.com/IlanCosman/tide) prompt
- **Terminal**: Ghostty with GPU acceleration
- **Editors**: Zed (primary), Neovim
- **Version Control**: Git with jj (Jujutsu), managed via jj
- **Version Management**: mise for runtime versions
- **SSH**: Secure SSH configuration with Tailscale integration

## Shell Configuration

### Fish Shell
- Modern command abbreviations and aliases
- Comprehensive function library organized by category:
  - Docker utilities (`dkclean`, `dklogs`, `dkprune`, `dksh`, `dkstats`)
  - Editor shortcuts (`c`, `e`, `v`, `z` with `_dot` variants)
  - Kubernetes tools (`kctx`, `kns`, `kpods`, `klogs`)
  - Navigation shortcuts (`d`, `dl`, `dt`, `doc`, `ghub`, `p`, `cdf`, `mkcd`, `tmpd`)
  - File operations (`extract`, `compress`, `cpv`, `mvv`, `symlink`)
  - Modern CLI replacements with fallbacks (`bat`, `eza`, `delta`, `btop`, `duf`, `dust`, `procs`)
  - Utilities (`calc`, `genpass`, `jsonf`, `timecmd`, `uuid`)
- Tide prompt theme managed via Fisher
- Plugins: Tide, fzf.fish
- Optimized startup with interactive-only initialization

### Terminal
- **Ghostty**: Fast GPU-accelerated terminal
- **Font**: JetBrains Mono Nerd Font

### Modern CLI Tools
Smart wrapper functions that fall back to standard tools when modern alternatives aren't available:
- `bat` → `cat`
- `eza` → `ls`
- `delta` → `diff`
- `btop` → `top`
- `duf` → `df`
- `dust` → `du`
- `procs` → `ps`
- `doggo` → `dig`
- `gping` → `ping`

## Installation

### Prerequisites
```bash
# Install chezmoi
brew install chezmoi  # macOS
# or
sudo dnf install chezmoi  # Fedora
```

### Initialize
```bash
chezmoi init https://github.com/nijaru/dotfiles.git
chezmoi apply --force
```

### Install Dependencies
```bash
# macOS
brew bundle --file=~/.local/share/chezmoi/Brewfile_darwin

# Fedora
# Tools installed via mise, dnf, cargo as needed
```

## Tools & Dependencies

### Core
- Fish shell
- Ghostty terminal
- Zed editor, Neovim
- mise (runtime version management)
- chezmoi (dotfile management)

### Development
- **Git**: git, git-delta, lazygit, jj (Jujutsu)
- **Languages**: Go, Rust, Python (uv), Zig, Elixir, Gleam
- **Containers**: Docker, Kubernetes tools (kubectl, kubectx, stern)
- **Modern CLI**: bat, eza, ripgrep, fd, zoxide, fzf, hyperfine

### Optional Enhanced Tools
- btop (system monitor)
- duf (disk usage)
- dust (disk usage alternative)
- procs (process viewer)
- doggo (DNS client)
- gping (ping with graph)
- difftastic (structural diff)

## Structure

```
.
├── dot_config/
│   ├── fish/           # Fish shell configuration
│   │   ├── conf.d/     # Auto-loaded config
│   │   ├── functions/  # Organized by category
│   │   └── fish_plugins # Fisher plugins
│   ├── ghostty/        # Ghostty terminal config
│   ├── nvim/           # Neovim configuration
│   ├── zed/            # Zed editor settings
│   ├── btop/           # System monitor config
│   ├── yazi/           # File manager config
│   ├── jj/             # Jujutsu VCS config
│   ├── mise/           # Runtime version config
│   └── starship.toml   # Starship prompt (alternative)
├── dot_claude/         # Claude Code configuration
│   └── CLAUDE.md       # Global AI agent instructions
├── dot_gitconfig       # Git configuration
├── dot_gitignore       # Global git ignore patterns
├── private_dot_ssh/    # SSH configuration
├── private_dot_cargo/  # Cargo build optimization
├── Brewfile_darwin     # macOS package list
└── run_once_*/         # One-time setup scripts
```

## Cross-Platform

Configuration works across:
- **macOS**: M3 Max (nick@apple)
- **Linux**: Fedora (nick@fedora)

Platform-specific files use `_darwin` or `_linux` suffix.

## Maintenance

```bash
# Check drift
chezmoi status

# Preview changes
chezmoi diff

# Apply changes
chezmoi apply --force

# Add new dotfile
chezmoi add ~/.config/newapp/config

# Update on remote machine
ssh nick@fedora 'chezmoi update && chezmoi apply --force'
```

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
