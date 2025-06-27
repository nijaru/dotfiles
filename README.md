# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell**: Fish shell with [Tide](https://github.com/IlanCosman/tide) prompt
- **Terminal**: Ghostty with Catppuccin Macchiato theme
- **Editor**: Zed with custom settings
- **Git**: Configured with global gitignore and templates
- **SSH**: Secure SSH configuration
- **Prompt**: Tide prompt for Fish shell

## Shell Configuration

### Fish Shell
- Modern command abbreviations and aliases
- Comprehensive function library organized by category:
  - Docker utilities (`dkclean`, `dklogs`, `dkprune`)
  - Git helpers (`gadd`, `gswitch`, `git-clean`)
  - Kubernetes tools (`kctx`, `kns`, `kpods`)
  - Navigation shortcuts (`cdf`, `mkcd`, `tmpd`)
  - File operations (`extract`, `compress`, `cpv`)
  - Modern CLI replacements (`bat`, `eza`, `rg`)
- Tide prompt theme with custom configuration
- Plugin management via Fisher

### Terminal
- **Ghostty**: Fast GPU-accelerated terminal
- **Theme**: Catppuccin Macchiato
- **Font**: JetBrains Mono Nerd Font

## Installation

1. Install [chezmoi](https://www.chezmoi.io/install/)
2. Initialize with this repository:
   ```bash
   chezmoi init https://github.com/yourusername/dotfiles.git
   ```
3. Apply the configuration:
   ```bash
   chezmoi apply
   ```

## Tools & Dependencies

This configuration assumes you have the following tools installed:
- Fish shell
- Ghostty terminal
- Zed editor
- Modern CLI tools: `bat`, `eza`, `rg`, `fd`, `delta`
- Docker and Kubernetes CLI tools
- Git

## Structure

```
.
├── dot_config/
│   ├── fish/           # Fish shell configuration
│   ├── ghostty/        # Ghostty terminal config
│   ├── starship.toml   # Starship prompt config
│   └── zed/            # Zed editor settings
├── dot_gitconfig.tmpl  # Git configuration template
├── dot_gitignore       # Global git ignore patterns
└── private_dot_ssh/    # SSH configuration
```

## License

This is free and unencumbered software released into the public domain.