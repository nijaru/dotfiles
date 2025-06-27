# CLAUDE.md - Dotfiles Repository Guide

## Repository Overview
Personal dotfiles for macOS/Linux development environments. Managed with chezmoi for configuration management. Optimized for speed, security, and productivity with Fish shell as the primary shell.

## Key Commands
```bash
chezmoi init                   # Initialize chezmoi dotfiles
chezmoi apply                  # Apply configuration changes
chezmoi add <file>             # Add file to chezmoi management
chezmoi edit <file>            # Edit managed file
chezmoi diff                   # Show differences between managed and actual files
chezmoi status                 # Show status of managed files
```

## Repository Structure
```
dotfiles/
├── config/                 # Application configurations
│   ├── fish/              # Fish shell configuration
│   │   ├── conf.d/        # Fish configuration directory
│   │   │   ├── abbr.fish     # General abbreviations
│   │   │   ├── git_abbr.fish # Git abbreviations
│   │   │   ├── paths.fish    # PATH configuration
│   │   │   └── ...           # Other config files
│   │   ├── functions/     # Fish functions organized by category
│   │   │   ├── docker/       # Container operations
│   │   │   ├── editor/       # Editor shortcuts
│   │   │   ├── fs/           # File system operations
│   │   │   ├── git/          # Git operations
│   │   │   ├── kubernetes/   # K8s operations
│   │   │   ├── modern-cli/   # Modern CLI tool wrappers
│   │   │   ├── navigation/   # Directory navigation
│   │   │   └── utils/        # Utility functions
│   │   ├── config.fish    # Main Fish configuration
│   │   ├── env.fish       # Environment variables
│   │   ├── dev.fish       # Development tools (Go, Python, Rust, etc.)
│   │   ├── docker.fish    # Docker/Kubernetes abbreviations
│   │   ├── darwin.fish    # macOS specific configuration
│   │   └── linux.fish     # Linux specific configuration
│   ├── ghostty/           # Terminal emulator
│   ├── zed/               # Code editor
│   └── starship.toml      # Shell prompt (alternative to Tide)
├── git/                    # Git configuration
├── ssh/                    # SSH configuration
├── gnupg/                  # GPG configuration
├── homebrew/               # Package management (Brewfile)
├── system/                 # System configurations
├── bin/                    # Custom scripts and binaries
└── archive/                # Archived/unused configurations
```

## Dependencies
- **Required**: Fish 3.3+, Git 2.25+, chezmoi
- **Primary Shell**: Fish shell with Tide prompt
- **Package Manager**: Homebrew (macOS)
- **Development Tools**: mise (runtime management), Tide (prompt)

## Code Style Guidelines
- **Fish**: Modular organization by functionality, consistent abbreviation patterns
- **Functions**: Organized in categorized directories (docker/, git/, utils/, etc.)
- **Config Files**: TOML/YAML preferred, maintain existing format consistency
- **Git**: Sign commits with SSH key, conventional commit messages
- **Security**: Proper file permissions, XDG Base Directory compliance

## File Organization Patterns
- Fish configs modularized by functionality (dev.fish, docker.fish, etc.)
- OS-specific files separated (darwin.fish, linux.fish)
- Functions organized in categorized directories under config/fish/functions/
- Application configs in `config/` directory by application name
- Configuration managed via chezmoi

## Common Tasks
- **Add new config**: Add file to chezmoi management with `chezmoi add`
- **Platform-specific config**: Use appropriate darwin.fish or linux.fish
- **New application config**: Create directory in config/ and add to chezmoi
- **Fish function**: Add to appropriate category directory in functions/
- **Abbreviation**: Add to relevant .fish file (abbr.fish, git_abbr.fish, dev.fish)

## Installation Flow
1. chezmoi init to initialize configuration management
2. chezmoi apply to deploy configurations to home directory
3. Configurations are symlinked/copied as appropriate
4. Fish shell loads modular configurations on startup
5. Platform-specific configurations loaded based on OS detection

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

## Fish Shell Configuration Details

### Function Organization
Functions are organized in categorized directories:
- **docker/**: Container operations (dksh, dklogs, dkclean, etc.)
- **editor/**: Editor shortcuts (e, v, z for different editors)
- **fs/**: File system operations (mkcd, extract, compress, etc.)
- **git/**: Git operations (gadd, gswitch, git-clean, etc.)
- **kubernetes/**: K8s operations (kctx, kns, kpods, etc.)
- **modern-cli/**: Modern CLI tool wrappers (ls→eza, top→btop, etc.)
- **navigation/**: Directory navigation shortcuts
- **utils/**: Utility functions (calc, genpass, uuid, etc.)

### Development Environment Support
- **Go**: Complete toolchain abbreviations (gor, got, gmt, etc.)
- **Python**: Virtual environment, pip, testing, linting
- **Rust**: Cargo operations, watch, clippy, fmt
- **Ruby**: Gem, bundle, rails, rspec support
- **Node.js**: npm, pnpm operations
- **Docker/K8s**: Comprehensive container management

## AI Agent Notes
- All modifications should maintain Fish shell best practices
- Test changes with Fish syntax before applying
- Follow modular approach for Fish configurations
- Respect XDG Base Directory specification where applicable
- Consider OS compatibility when adding new configurations
- Use chezmoi for configuration management