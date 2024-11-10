#!/usr/bin/env zsh

###################
# macOS Security & Integration
###################
# SSH/GPG Configuration
export SSH_AUTH_SOCK="$HOME/.ssh/agent"
export GPG_TTY=$(tty)
export APPLE_SSH_ADD_BEHAVIOR="macos"

# Keychain Integration
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

###################
# Performance & Optimization
###################
# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BAT=1
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_INSTALL_CLEANUP=1     # Auto cleanup old versions
export HOMEBREW_CURL_RETRIES=3        # More resilient downloads
export HOMEBREW_PARALLEL_JOBS="$(sysctl -n hw.ncpu)"  # Parallel downloads

# Set keyboard type for z4h
zstyle ':z4h:bindkey' keyboard 'mac'

###################
# Path & Environment
###################
# Ensure homebrew is in path
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Modular AI - using $HOME for portability
export PATH="$PATH:$HOME/.modular/bin"
if command -v magic >/dev/null; then
    eval "$(magic completion --shell zsh)"
fi

###################
# OrbStack Configuration
###################
export DOCKER_HOST="unix://$HOME/.orbstack/run/docker.sock"
export DOCKER_DEFAULT_PLATFORM="linux/arm64"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

[[ -f ~/.orbstack/shell/init.zsh ]] && source ~/.orbstack/shell/init.zsh

# If orbctl exists, add completion
if (( $+commands[orbctl] )); then
  eval "$(orbctl completion zsh)"
  compdef _orb orbctl
  compdef _orb orb
fi

###################
# macOS Utilities
###################
# System commands
alias disk="diskutil"
alias tar="gtar"
alias o="open"
alias oa="open -a"
alias reveal="open -R"
alias finder="open -a Finder"

# Clipboard
alias clip="pbcopy"
alias paste="pbpaste"

# File operations
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias ql="qlmanage -p"

###################
# System Maintenance
###################
# Clear system caches
alias cleardns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias clearfonts="sudo atsutil databases -remove"
alias clearmeta="find . -type f -name '*.DS_Store' -ls -delete"

# System update and maintenance
alias update="brew update && brew upgrade && brew cleanup && rustup update && pipx upgrade-all && z4h update"
alias up="brew update && brew upgrade && brew cleanup"

# Homebrew package management
alias brews="brew search"
alias brewin="brew info"
alias brewi="brew install"
alias brewu="brew update && brew upgrade"
alias brewx="brew uninstall"
alias brewl="brew list"
alias brewc="brew cleanup --prune=all"  # More thorough cleanup
alias brewd="brew doctor"              # Check system for potential problems
alias brewdeps="brew deps --tree"      # Show dependency tree

# Cask management
alias caskin="brew info --cask"
alias casks="brew search --cask"
alias caski="brew install --cask"
alias caskx="brew uninstall --cask"
alias caskl="brew list --cask"

if [ -x /usr/libexec/path_helper ]; then
    eval $(/usr/libexec/path_helper -s)
fi
