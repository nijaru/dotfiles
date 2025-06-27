# dotfiles

Personal dotfiles for configuring development environments on macOS and Linux, optimized for speed and productivity.

## Overview

This repository contains a comprehensive set of configuration files for:

- Shell (Zsh with Z4H)
- Development Tools & Languages
- Security & Authentication
- Terminal Emulators & Editors
- Container & Cloud Tools

## Key Features

- Asynchronous ZSH configuration with Z4H
- Extensive language-specific development environments
- Security-focused SSH and GPG configuration
- Modern CLI replacements for standard tools
- Customized development environments for:
  - Python, Go, Rust, Node.js, Ruby
  - Docker and Kubernetes
  - Git with advanced workflows
  - Cloud tools (AWS, GCP, Azure)

## Prerequisites

- Zsh 5.8+
- Python 3.6+
- Git 2.25+
- [Z4H (Zsh for Humans)](https://github.com/romkatv/zsh4humans)

### Quick Start

```bash
# Install Z4H if not present
if ! command -v z4h >/dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

# Clone and install dotfiles
git clone https://github.com/nijaru/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
./install.py
```

## Directory Structure

```
dotfiles/
├── shell/           # Shell configuration
│   ├── .zshenv      # Environment setup
│   ├── .zshrc       # Main shell configuration
│   ├── .env.zsh     # Environment variables
│   ├── .aliases.zsh # General aliases
│   ├── .git.zsh     # Git aliases and functions
│   ├── .dev.zsh     # Development tools
│   ├── .docker.zsh  # Container operations
│   ├── .darwin.zsh  # macOS specific
│   └── .linux.zsh   # Linux specific
├── git/             # Git configuration
│   ├── .gitconfig   # Git settings
│   └── .gitignore   # Global ignores
├── ssh/             # SSH configuration
│   └── config       # SSH settings
├── gnupg/           # GPG configuration
│   └── gpg-agent.conf
├── config/          # Application configs
│   ├── kitty/       # Terminal emulator
│   ├── zed/         # Code editor
│   └── htop/        # System monitor
├── homebrew/        # Package management
│   └── Brewfile     # macOS packages
├── misc/            # Additional files
├── install.py       # Installation script
└── README.md
```

## Installation

The installation script provides several options:

```bash
./install.py [options]

Options:
  --force      Force overwrite existing files
  --no-backup  Skip backup creation
  --dry-run    Show changes without applying
  --help       Show help message
```

### Features

- Automatic backup of existing configurations
- OS-specific installations (macOS/Linux)
- XDG Base Directory support
- Secure file permissions

## Configuration

### Shell

- Optimized Zsh configuration with Z4H
- Extensive aliases and functions
- Platform-specific customizations
- Development environment integration

### Development

- Language-specific configurations
- Container and cloud tool integration
- Modern CLI replacements
- Comprehensive Git workflow

### Security

- SSH configuration with connection sharing
- GPG agent setup (macOS)
- Secure default permissions

## Customization

1. Fork this repository
2. Modify configurations as needed
3. Update Brewfile for different packages
4. Adjust installation script

## License

MIT License - See [LICENSE](LICENSE) file for details

## Author

[nijaru](https://github.com/nijaru)
