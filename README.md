# dotfiles

Personal dotfiles for configuring development environments on macOS and Linux.

## Overview

This repository contains configuration files for:

- Shell (Zsh + Z4H)
- Git
- SSH
- GPG
- Terminal Emulators (Kitty)
- Development Tools (Zed, htop)
- Package Management (Homebrew, DNF)

## Directory Structure

```
dotfiles/
├── shell/           # Zsh and shell-related configs
├── git/            # Git configuration
├── ssh/            # SSH configuration
├── gnupg/          # GPG configuration
├── config/         # Application configurations
│   ├── kitty/
│   ├── zed/
│   └── htop/
├── homebrew/       # Homebrew bundle
├── system/         # System-specific configs
├── install.py      # Python installation script
└── README.md
```

## Prerequisites

- Python 3.6+
- Git
- Zsh

## Installation

1. Clone the repository:

```bash
git clone https://github.com/nijaru/dotfiles.git ~/github/dotfiles
```

2. Run the installation script:

```bash
cd ~/github/dotfiles
./install.py
```

### Installation Options

The installer supports several command-line options:

```bash
./install.py [options]

Options:
  --force      Force installation, overwriting existing files
  --no-backup  Skip creating backups of existing files
  --dry-run    Show what would be done without making changes
  --help       Show this help message
```

## Features

### Automated Installation

The Python installer provides:

- Automatic backup of existing configurations
- Rollback capability if installation fails
- OS-specific configurations for macOS and Linux
- Colored logging output
- Dry-run capability

### Shell Configuration

- Z4H (Zsh for Humans) as the shell framework
- Custom aliases and functions
- Environment variables
- OS-specific configurations

### Security

- SSH configuration with control master support
- GPG agent configuration (macOS)
- Secure file permissions

### Development Tools

- Git configuration with useful aliases
- Kitty terminal emulator configuration
- Zed editor settings
- htop system monitor configuration

### Package Management

- Homebrew bundle for macOS
- DNF configuration for Fedora/RHEL systems

## Backup System

The installer automatically creates timestamped backups in `~/.dotfiles_backups/`:

- Maintains the last 5 backups
- Secure backup permissions (700)
- Automatic cleanup of older backups

## OS Support

### macOS

- Full support for all features
- Homebrew package management
- GPG agent configuration

### Linux

- Shell and development tools configuration
- System-specific adjustments
- DNF configuration (Fedora/RHEL)

## Customization

To customize these dotfiles:

1. Fork this repository
2. Modify configurations as needed
3. Update the Brewfile for different package selections
4. Adjust the installation script for new configurations

## Troubleshooting

If installation fails:

1. Check the error messages in the console output
2. Verify all prerequisites are installed
3. Use `--dry-run` to test changes
4. Check permissions on target directories

All changes are automatically rolled back on failure.

## License

MIT License - See [LICENSE](LICENSE) file for details

## Author

[nijaru](https://github.com/nijaru)
