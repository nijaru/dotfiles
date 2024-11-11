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
- Package Management (Homebrew)

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
├── install.sh      # Installation script
└── README.md
```

## Prerequisites

1. Install Zsh4Humans:

```bash
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
```

## Installation

1. Clone the repository:

```bash
git clone https://github.com/nijaru/dotfiles.git ~/github/dotfiles
```

2. Run the installation script:

````bash
cd ~/github/dotfiles
./install.sh

## Installation

1. Clone the repository:

```bash
git clone https://github.com/nijaru/dotfiles.git ~/github/dotfiles
````

2. Run the installation script:

```bash
cd ~/github/dotfiles
./install.sh
```

The script will install configurations in this order:

1. Install system packages (Homebrew on macOS, DNF config on Linux)
2. Configure security (SSH and GPG)
3. Set up Git configuration
4. Configure shell environment
5. Install application-specific configurations

This order ensures that:

- Required packages are available for all tools
- SSH and GPG are ready for Git operations
- Shell and application configurations have all dependencies met

## Features

### Shell Configuration

- Z4H (Zsh for Humans) as the shell framework
- Custom aliases and functions
- Environment variables
- OS-specific configurations for macOS and Linux

### Development Tools

- Git configuration with useful aliases
- SSH and GPG setup for secure development
- Kitty terminal emulator configuration
- Zed editor settings
- htop system monitor configuration

### Package Management

- Homebrew bundle for macOS software installation
- DNF configuration for Fedora/RHEL systems

## OS Support

### macOS

- Full support for all features
- Homebrew package installation
- GPG agent configuration

### Linux

- Shell and development tools configuration
- System-specific adjustments for paths and tools
- DNF configuration for Fedora/RHEL systems

## Backup

The installation script automatically backs up existing configurations to `~/.dotfiles.bak` with timestamps before creating new symlinks.

## Customization

To customize these dotfiles:

1. Fork this repository
2. Modify configurations as needed
3. Update the Brewfile for different package selections
4. Adjust the installation script if adding new configurations

## License

MIT License

## Author

[nijaru](https://github.com/nijaru)
