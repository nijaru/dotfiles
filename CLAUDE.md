# CLAUDE.md - Dotfiles Repository Guide

## Commands
- `./install.py` - Install dotfiles (symlinks config files to home directory)
- `./install.py --dry-run` - Show changes without applying
- `./install.py --force` - Force overwrite existing files
- Python linting: `ruff check`
- Python formatting: `ruff format`

## Code Style
- **Python**: 4 spaces, ruff for linting/formatting, line length 88
- **Go**: hard tabs, gofumpt formatter
- **JS/TS**: Biome for linting/formatting
- **C++**: 4 spaces, clangd formatter, line length 88
- **Git**: Sign all commits with SSH key
- **Shell**: Z4H for Zsh configuration

## Naming Conventions
- Use snake_case for Python variables and functions
- Use descriptive variable names with proper type hints
- Keep functions small and focused on a single task
- Separate logical sections with comment blocks

## Repository Structure
- Organized by technology/tool (shell, git, config, etc.)
- Configuration files are symlinked to home directory
- OS-specific configurations handled separately
- Security-focused with proper file permissions
- Minimalist approach with emphasis on speed