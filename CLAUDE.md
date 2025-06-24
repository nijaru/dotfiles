# CLAUDE.md - Dotfiles Repository Guide

## Repository Overview
Personal dotfiles for macOS/Linux development environments. Symlinks configurations to home directory via Python installer. Optimized for speed, security, and productivity.

## Key Commands
```bash
./install.py                    # Install dotfiles (create symlinks)
./install.py --dry-run         # Preview changes without applying
./install.py --force           # Overwrite existing files
./install.py --no-backup       # Skip backup creation
ruff check                     # Python linting
ruff format                    # Python formatting
```

## Repository Structure
```
dotfiles/
├── install.py              # Main installer (Python 3.6+)
├── shell/                  # Zsh configuration with Z4H
│   ├── .zshenv            # Environment variables
│   ├── .zshrc             # Main shell config
│   ├── .aliases.zsh       # General aliases
│   ├── .functions.zsh     # Shell functions
│   ├── .git.zsh           # Git aliases/functions
│   ├── .dev.zsh           # Development tools
│   ├── .docker.zsh        # Container operations
│   ├── .darwin.zsh        # macOS specific
│   └── .linux.zsh         # Linux specific
├── config/                 # Application configurations
│   ├── fish/              # Fish shell
│   ├── ghostty/           # Terminal emulator
│   ├── helix/             # Text editor
│   ├── kitty/             # Terminal emulator
│   ├── zed/               # Code editor
│   └── starship.toml      # Shell prompt
├── git/                    # Git configuration
├── ssh/                    # SSH configuration
├── gnupg/                  # GPG configuration
├── homebrew/               # Package management (Brewfile)
├── misc/                   # Additional files
└── system/                 # System configurations
```

## Dependencies
- **Required**: Zsh 5.8+, Python 3.6+, Git 2.25+
- **Primary Shell**: Z4H (Zsh for Humans)
- **Package Manager**: Homebrew (macOS)
- **Python Tools**: ruff (linting/formatting)

## Code Style Guidelines
- **Python**: 4 spaces, ruff formatting, line length 88, type hints required
- **Shell**: Follow Z4H patterns, modular .zsh files by function
- **Config Files**: TOML/YAML preferred, maintain existing format consistency
- **Git**: Sign commits with SSH key, conventional commit messages
- **Security**: Proper file permissions (0o644 for configs, 0o600 for sensitive)

## File Organization Patterns
- Shell configs modularized by functionality (.dev.zsh, .docker.zsh, etc.)
- OS-specific files separated (.darwin.zsh, .linux.zsh)
- Application configs in `config/` directory by application name
- Symlink targets defined in install.py CORE_CONFIGS and PLATFORM_CONFIGS

## Common Tasks
- **Add new config**: Update install.py with (source, target, mode) tuple
- **Platform-specific config**: Use appropriate .darwin.zsh or .linux.zsh
- **New application config**: Create directory in config/ and update installer
- **Shell function**: Add to .functions.zsh with descriptive comments
- **Alias**: Add to appropriate .zsh file (.aliases.zsh, .git.zsh, .dev.zsh)

## Installation Flow
1. install.py reads CORE_CONFIGS and PLATFORM_CONFIGS
2. Creates backups of existing files (unless --no-backup)
3. Creates symlinks from dotfiles/ to home directory
4. Applies specified file permissions
5. Handles XDG Base Directory specification

## Security Features
- SSH configuration with connection sharing
- GPG agent setup for commit signing
- Secure file permissions enforced
- Sensitive configs (SSH, GPG) have restricted access

## Development Environment
- Multi-language support (Python, Go, Rust, Node.js, Ruby)
- Container tools (Docker, Kubernetes)
- Cloud CLI tools (AWS, GCP, Azure)
- Modern CLI replacements and productivity tools
- Git workflow optimizations

## AI Agent Notes
- All modifications should maintain existing file permission patterns
- Test changes with --dry-run before applying
- Follow modular approach for shell configurations
- Respect XDG Base Directory specification where applicable
- Consider OS compatibility when adding new configurations