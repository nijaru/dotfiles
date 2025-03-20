#!/usr/bin/env fish
# Core environment configuration for Fish

# Core environment variables
set -gx EDITOR "zed"
set -gx VISUAL "zed"
set -gx ALTERNATE_EDITOR "nvim"
set -gx MOAR "--style=catppuccin-macchiato --quit-if-one-screen --no-statusbar --wrap"
set -gx BAT_THEME "Catppuccin Macchiato"

# XDG Base Directories
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_RUNTIME_DIR "/run/user/$UID"

# Ensure critical directories exist
for dir in \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_CACHE_HOME/fish" \
    "$XDG_STATE_HOME/less" \
    "$XDG_DATA_HOME/gem" \
    "$XDG_CONFIG_HOME/bundle"
    mkdir -p $dir
end

# Development Tools Paths
set -gx MISE_CONFIG_DIR "$XDG_CONFIG_HOME/mise"
set -gx MISE_DATA_DIR "$XDG_DATA_HOME/mise"
set -gx MISE_CACHE_DIR "$XDG_CACHE_HOME/mise"

# Container Configuration
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1

# Go Language Settings
set -gx GOPATH "$HOME/go"
set -gx GOBIN "$GOPATH/bin"
set -gx GOTOOLCHAIN "local"
set -gx GOFLAGS "-buildvcs=false -trimpath"

# Rust Language Settings
set -gx CARGO_HOME "$HOME/.cargo"
set -gx RUSTUP_HOME "$HOME/.rustup"
set -gx RUST_BACKTRACE 1

# Node.js Settings
set -gx NODE_ENV "development"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# Python Settings
set -gx PYTHONDONTWRITEBYTECODE 1 # Prevent .pyc files
set -gx PYTHONUNBUFFERED 1        # Disable output buffering
set -gx PYTHONFAULTHANDLER 1      # Better tracebacks
set -gx PYTHONHASHSEED "random"   # Secure hash seeds

# Ruby Configuration
set -gx GEM_HOME "$XDG_DATA_HOME/gem"
set -gx GEM_PATH "$GEM_HOME:$XDG_DATA_HOME/gem"
set -gx BUNDLE_USER_HOME "$XDG_CONFIG_HOME/bundle"

# Modular
contains "$HOME/.modular/bin" $PATH; or set -gx PATH "$HOME/.modular/bin" $PATH

# Platform-specific settings
switch (uname -s)
    case Darwin
        # GPG Configuration
        set -gx GPG_TTY (tty)
        # CPU/Memory optimizations
        set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY "YES"
        # Container Configuration (Docker & OrbStack)
        set -gx DOCKER_HOST "unix://$HOME/.orbstack/run/docker.sock"
        set -gx DOCKER_DEFAULT_PLATFORM "linux/arm64"
        
        # Homebrew setup
        switch (uname -m)
            case arm64 aarch64
                eval (/opt/homebrew/bin/brew shellenv)
            case '*'
                eval (/usr/local/bin/brew shellenv)
        end
end

# Path Configuration (Fish handles path deduplication automatically)
fish_add_path $HOME/.local/bin
fish_add_path $GOBIN
fish_add_path $CARGO_HOME/bin
fish_add_path $HOME/.mise/bin
fish_add_path $GEM_HOME/bin
fish_add_path $HOME/.modular/bin