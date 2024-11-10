#!/usr/bin/env zsh

###################
# Security & Privacy
###################
# SSH/GPG Configuration
export SSH_AUTH_SOCK="$HOME/.ssh/agent"
export GPG_TTY=$(tty)
export APPLE_SSH_ADD_BEHAVIOR="macos"

# Security settings
export HOMEBREW_NO_INSECURE_REDIRECT=1      # Prevent insecure redirects
export HOMEBREW_CASK_OPTS="--require-sha"   # Require SHA verification for casks

# Keychain Integration
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

###################
# Performance Optimizations
###################
# CPU/Memory optimizations
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES  # Better fork performance
export MAKEFLAGS="-j$(sysctl -n hw.ncpu)"      # Parallel compilation
export ARCHFLAGS="-arch $(uname -m)"           # Native architecture flags

# Homebrew optimizations
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BAT=1
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_NO_AUTO_UPDATE=1              # Manual updates only
export HOMEBREW_INSTALL_CLEANUP=1             # Auto cleanup old versions
export HOMEBREW_CURL_RETRIES=3               # More resilient downloads
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1  # Don't fallback to source
export HOMEBREW_PARALLEL_JOBS="$(sysctl -n hw.ncpu)"  # Parallel operations

# Cache optimizations
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p $ZSH_CACHE_DIR

###################
# Development Environment
###################
# Architecture and Homebrew setup
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Rosetta 2 support if needed
    alias ibrew='arch -x86_64 /usr/local/bin/brew'
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Modular AI
export PATH="$PATH:$HOME/.modular/bin"
if command -v magic >/dev/null; then
    eval "$(magic completion --shell zsh)"
fi

###################
# Container Configuration
###################
# OrbStack settings
export DOCKER_HOST="unix://$HOME/.orbstack/run/docker.sock"
export DOCKER_DEFAULT_PLATFORM="linux/arm64"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_CLI_HINTS=false              # Disable CLI hints

[[ -f ~/.orbstack/shell/init.zsh ]] && source ~/.orbstack/shell/init.zsh

# OrbStack completion
if (( $+commands[orbctl] )); then
    eval "$(orbctl completion zsh)"
    compdef _orb orbctl
    compdef _orb orb
fi

###################
# macOS Utilities
###################
# System commands (unique to macOS)
alias disk="diskutil"
alias tar="gtar"
alias o="open"
alias oa="open -a"
alias reveal="open -R"
alias finder="open -a Finder"

# File operations (macOS specific)
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias ql="qlmanage -p"

# Clipboard operations (macOS specific)
alias clip="pbcopy"
alias paste="pbpaste"

###################
# System Maintenance
###################
# macOS specific maintenance
alias clear-fontcache="sudo atsutil databases -remove"
alias clear-quicklook="qlmanage -r cache"
alias rebuild-spotlight="sudo mdutil -E /"
alias repair-perms="sudo diskutil resetUserPermissions / $(id -u)"

# App Store management (if mas is installed)
if command -v mas &> /dev/null; then
    alias appstore-updates="mas outdated"
    alias appstore-upgrade="mas upgrade"
fi

###################
# Power Management
###################
# Power related commands
alias battery-health="system_profiler SPPowerDataType"
alias power-usage="pmset -g stats"
alias sleep-settings="pmset -g"
alias prevent-sleep="caffeinate -d"        # Prevent display sleep
alias allow-sleep="killall caffeinate"     # Allow sleep again

###################
# Network Management
###################
# macOS specific network commands
alias wifi-history="defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences RememberedNetworks | grep SSIDString"
alias wifi-scan="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport scan"
alias wifi-pass="security find-generic-password -wa"
alias flush-dns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

###################
# Path Management
###################
# Ensure path_helper runs last
if [ -x /usr/libexec/path_helper ]; then
    eval $(/usr/libexec/path_helper -s)
fi

# Clean up PATH
typeset -U PATH path
