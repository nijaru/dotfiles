#!/usr/bin/env bash

set -euo pipefail

###################
# Constants
###################
DOTFILES_DIR="$HOME/github/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

###################
# Helper Functions
###################
log_info() { echo -e "${GREEN}INFO:${NC} $1"; }
log_warn() { echo -e "${YELLOW}WARN:${NC} $1"; }
log_error() { echo -e "${RED}ERROR:${NC} $1" >&2; }

# Error handling
cleanup() {
    if [ $? -ne 0 ]; then
        log_error "An error occurred during installation!"
        log_info "Backup files are located at: $BACKUP_DIR"
    fi
}
trap cleanup EXIT

# Validate environment
check_dependencies() {
    local missing_deps=()
    for cmd in "$@"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# Backup existing file
backup_file() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/$(basename "$file")"
        log_info "Backed up $file to $BACKUP_DIR/$(basename "$file")"
    fi
}

# Create symlink with validation
link_file() {
    local src="$1"
    local dest="$2"
    local force="${3:-false}"

    if [ ! -e "$src" ]; then
        log_error "Source file does not exist: $src"
        return 1
    fi

    backup_file "$dest"

    mkdir -p "$(dirname "$dest")"
    if ln -sf "$src" "$dest"; then
        log_info "Linked $src to $dest"
    else
        log_error "Failed to link $src to $dest"
        return 1
    fi
}

# Set secure permissions
set_permissions() {
    local path="$1"
    local perms="$2"
    if ! chmod "$perms" "$path"; then
        log_error "Failed to set permissions on $path"
        return 1
    fi
}

###################
# Installation Functions
###################
install_zsh4humans() {
    log_info "Installing zsh4humans..."

    # Remove existing z4h installation if it exists
    if [[ -d "${HOME}/.zsh4humans" ]]; then
        log_info "Removing existing zsh4humans installation..."
        rm -rf "${HOME}/.zsh4humans"
    fi

    # Create temporary installation script
    local tmp_script=$(mktemp)
    cat > "$tmp_script" << 'EOF'
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)" "" --branch v5
elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)" "" --branch v5
fi
EOF

    # Make script executable
    chmod +x "$tmp_script"

    # Run the installation script in an interactive terminal
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS, use Terminal.app
        osascript -e "tell application \"Terminal\" to do script \"$tmp_script\""
        log_info "Please complete the zsh4humans installation in the new Terminal window"
        log_info "After installation is complete, close the Terminal window and press Enter to continue"
        read -p "Press Enter when zsh4humans installation is complete..."
    else
        # For Linux, try direct execution
        "$tmp_script"
    fi

    # Clean up
    rm -f "$tmp_script"

    # Verify installation
    if [[ -d "${HOME}/.zsh4humans" ]]; then
        log_info "zsh4humans installation verified"
        return 0
    else
        log_error "zsh4humans installation could not be verified"
        return 1
    fi
}

setup_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH based on architecture
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    if [[ -f "$DOTFILES_DIR/misc/Brewfile" ]]; then
        log_info "Installing Homebrew packages..."
        brew bundle --file="$DOTFILES_DIR/misc/Brewfile" || {
            log_error "Failed to install Homebrew packages"
            return 1
        }
    fi
}

setup_linux_packages() {
    if command -v dnf >/dev/null 2>&1; then
        log_info "Setting up DNF configuration..."
        sudo mkdir -p /etc/dnf
        sudo cp "$DOTFILES_DIR/misc/dnf.conf" /etc/dnf/dnf.conf
    elif command -v apt >/dev/null 2>&1; then
        log_info "Updating apt package list..."
        sudo apt update
    fi
}

install_core_files() {
    log_info "Installing core configuration files..."

    # Shell configuration
    link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    link_file "$DOTFILES_DIR/.env.zsh" "$HOME/.env.zsh"
    link_file "$DOTFILES_DIR/.functions.zsh" "$HOME/.functions.zsh"
    link_file "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
    link_file "$DOTFILES_DIR/.aliases-git" "$HOME/.aliases-git"

    # Git configuration
    link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    link_file "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
}

install_ssh_config() {
    log_info "Setting up SSH configuration..."

    mkdir -p "$HOME/.ssh"
    set_permissions "$HOME/.ssh" 700

    link_file "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
    set_permissions "$HOME/.ssh/config" 600

    mkdir -p "$HOME/.ssh/control"
    set_permissions "$HOME/.ssh/control" 700
}

install_gpg_config() {
    log_info "Setting up GPG configuration..."

    mkdir -p "$HOME/.gnupg"
    set_permissions "$HOME/.gnupg" 700

    link_file "$DOTFILES_DIR/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
    set_permissions "$HOME/.gnupg/gpg-agent.conf" 600
}

install_editor_configs() {
    # Kitty configuration
    if command -v kitty >/dev/null 2>&1; then
        log_info "Setting up Kitty configuration..."
        mkdir -p "$CONFIG_DIR/kitty"
        link_file "$DOTFILES_DIR/misc/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"
    fi

    # Zed configuration (macOS only)
    if command -v zed >/dev/null 2>&1; then
        log_info "Setting up Zed configuration..."
        mkdir -p "$CONFIG_DIR/zed"
        link_file "$DOTFILES_DIR/misc/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
    fi
}

###################
# Main Script
###################
main() {
    # Check for required tools
    check_dependencies zsh git curl

    log_info "Starting dotfiles installation..."

    # Install zsh4humans first
    if ! install_zsh4humans; then
        log_error "Failed to install zsh4humans. Cannot continue."
        exit 1
    fi

    # Platform-specific setup
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Setting up macOS environment..."
        setup_homebrew
        link_file "$DOTFILES_DIR/.darwin.zsh" "$HOME/.darwin.zsh"
        install_gpg_config
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_info "Setting up Linux environment..."
        setup_linux_packages
        link_file "$DOTFILES_DIR/.linux.zsh" "$HOME/.linux.zsh"
    else
        log_warn "Unsupported operating system: $OSTYPE"
    fi

    # Install configurations
    install_core_files
    install_ssh_config
    install_editor_configs

    log_info "✨ Dotfiles installation complete!"

    # Post-installation messages
    cat << EOF

🔍 Post-installation steps:
1. Restart your shell or run: source ~/.zshrc
2. If using GPG, set up your keys
3. Verify symlinks with: ls -la ~
4. Check backup directory: $BACKUP_DIR

For more information, visit: https://github.com/nijaru/dotfiles
EOF
}

main "$@"
