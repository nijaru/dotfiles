# Personal Dotfiles

A comprehensive, security-focused dotfiles repository for macOS and Linux development environments. Managed with [chezmoi](https://chezmoi.io/) for reliable configuration management and optimized for speed, security, and productivity with Fish shell.

## 🚀 Quick Start

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply https://github.com/YOUR_USERNAME/dotfiles.git
```

## ✨ Features

- **🐠 Fish Shell**: Modern shell with intelligent autocompletion and syntax highlighting
- **⚡ Performance**: Optimized for speed with lazy loading and efficient configurations
- **🔒 Security**: SSH key management, GPG signing, and secure file permissions
- **🛠️ Development**: Multi-language support with modern tooling
- **📦 Package Management**: Automated setup with Homebrew (macOS)
- **🔄 Sync**: Cross-platform compatibility with OS-specific configurations

## 🏗️ Architecture

### Core Technologies
- **Shell**: Fish 3.3+ with [Tide](https://github.com/IlanCosman/tide) prompt
- **Config Management**: [chezmoi](https://chezmoi.io/) for dotfile management
- **Runtime Management**: [mise](https://mise.jdx.dev/) for language versions
- **Package Manager**: Homebrew (macOS), system package managers (Linux)

### Directory Structure
```
~/.local/share/chezmoi/
├── config/                    # Application configurations
│   ├── fish/                  # Fish shell configuration
│   │   ├── conf.d/           # Fish configuration modules
│   │   │   ├── abbr.fish     # General abbreviations
│   │   │   ├── git_abbr.fish # Git abbreviations  
│   │   │   ├── paths.fish    # PATH configuration
│   │   │   └── ...
│   │   ├── functions/        # Organized fish functions
│   │   │   ├── docker/       # Container operations
│   │   │   ├── editor/       # Editor shortcuts
│   │   │   ├── fs/           # File system utilities
│   │   │   ├── git/          # Git operations
│   │   │   ├── kubernetes/   # K8s management
│   │   │   ├── modern-cli/   # Modern CLI wrappers
│   │   │   ├── navigation/   # Directory navigation
│   │   │   └── utils/        # Utility functions
│   │   ├── config.fish       # Main Fish configuration
│   │   ├── env.fish          # Environment variables
│   │   ├── dev.fish          # Development tools
│   │   ├── docker.fish       # Container abbreviations
│   │   ├── darwin.fish       # macOS specific config
│   │   └── linux.fish        # Linux specific config
│   ├── ghostty/              # Terminal emulator
│   ├── zed/                  # Code editor
│   └── starship.toml         # Alternative shell prompt
├── git/                      # Git configuration
├── ssh/                      # SSH configuration  
├── gnupg/                    # GPG configuration
├── homebrew/                 # Package management
│   └── Brewfile             # macOS packages
├── system/                   # System configurations
├── bin/                      # Custom scripts
└── archive/                  # Archived configurations
```

## 🛠️ Development Environment

### Languages & Runtimes
- **Go**: Complete toolchain with testing, benchmarking, and module management
- **Python**: Virtual environments, pip, testing frameworks, and linting
- **Rust**: Cargo operations, clippy, formatting, and watch mode
- **Node.js**: npm, pnpm, yarn support with version management
- **Ruby**: Gem, bundle, Rails, and RSpec integration

### Tools & CLI
- **Containers**: Docker, Kubernetes with extensive shortcuts
- **Cloud**: AWS, GCP, Azure CLI tools and configurations  
- **Modern CLI**: `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep), `btop` (top)
- **Git**: Advanced workflows, signing, and productivity shortcuts
- **Editors**: Zed, Neovim, VS Code integration

### Fish Functions (Examples)
```fish
# Container operations
dksh container_name          # Shell into container
dklogs container_name        # View container logs
dkclean                      # Clean Docker system

# Git operations  
gadd                         # Interactive git add
gswitch branch_name          # Switch/create branch
git-clean                    # Clean merged branches

# Kubernetes
kctx context_name            # Switch context
kns namespace_name           # Switch namespace
kpods                        # List pods

# File operations
mkcd directory_name          # Create and enter directory
extract archive.tar.gz       # Extract any archive
uuid                         # Generate UUID
```

## 🔧 Installation

### Prerequisites
- Fish shell 3.3+
- Git 2.25+
- curl or wget

### Full Installation
```bash
# 1. Install chezmoi
curl -sfL https://git.io/chezmoi | sh

# 2. Initialize and apply dotfiles
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
chezmoi apply

# 3. Install packages (macOS)
brew bundle --file ~/.config/homebrew/Brewfile

# 4. Set Fish as default shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### Key Commands
```bash
chezmoi init                 # Initialize chezmoi
chezmoi apply               # Apply configuration changes  
chezmoi add <file>          # Add file to management
chezmoi edit <file>         # Edit managed file
chezmoi diff                # Show differences
chezmoi status              # Show status
```

## 🔒 Security Features

- **SSH**: Connection sharing, agent forwarding, and secure defaults
- **GPG**: Automatic agent setup for commit signing
- **File Permissions**: Secure defaults for sensitive configurations
- **XDG Compliance**: Follows XDG Base Directory specification
- **Secrets Management**: Secure handling of sensitive data with chezmoi

## 🎨 Customization

### Adding New Configurations
```bash
# Add application config
chezmoi add ~/.config/app/config.yml

# Edit existing config
chezmoi edit ~/.config/fish/config.fish

# Add new Fish function
chezmoi add ~/.config/fish/functions/category/new_function.fish
```

### Platform-Specific Config
- **macOS**: Add to `darwin.fish` or create `*.darwin.fish` files
- **Linux**: Add to `linux.fish` or create `*.linux.fish` files
- **Conditional**: Use chezmoi templates for complex conditions

## 📋 Requirements

### System Dependencies
- **macOS**: Homebrew, Xcode Command Line Tools
- **Linux**: Package manager (apt, yum, pacman), build tools
- **All**: Git, curl, Fish shell

### Optional Enhancements
- [Tide](https://github.com/IlanCosman/tide) - Fish shell prompt
- [mise](https://mise.jdx.dev/) - Runtime version management
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [Zed](https://zed.dev/) - Code editor

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test changes thoroughly
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙋‍♂️ Author

Created and maintained by [Your Name](https://github.com/YOUR_USERNAME)

---

*Optimized for developer productivity and modern workflows. Continuously updated with the latest tools and best practices.*