#!/usr/bin/env zsh
# .env.zsh - Core environment configuration
# Defines base environment variables and paths used across the system

###################
# XDG Base Directories
###################
# Core XDG paths - used by many applications
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

# Ensure critical directories exist
() {
    local -a xdg_dirs=(
        "$XDG_CONFIG_HOME"
        "$XDG_CACHE_HOME"
        "$XDG_DATA_HOME"
        "$XDG_STATE_HOME"
        "${XDG_CACHE_HOME}/zsh"
        "${XDG_STATE_HOME}/less"
        "${XDG_DATA_HOME}/gem"
        "${XDG_CONFIG_HOME}/bundle"
    )
    for dir in $xdg_dirs; do
        [[ -d "$dir" ]] || mkdir -p "$dir"
    done
}

###################
# Shell Configuration
###################
# History configuration
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Default editors
export EDITOR="zed"
export VISUAL="zed"
export ALTERNATE_EDITOR="nvim"

# Pager settings
export PAGER="moar"
export MOAR="--style=catppuccin-mocha --quit-if-one-screen --no-statusbar --wrap"

# Bat configuration
export BAT_THEME="gruvbox-dark"

###################
# Tool Configuration
###################
# Development tools
export MISE_CONFIG_DIR="${XDG_CONFIG_HOME}/mise"
export MISE_DATA_DIR="${XDG_DATA_HOME}/mise"
export MISE_CACHE_DIR="${XDG_CACHE_HOME}/mise"

# Container configuration
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Language-specific settings
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOTOOLCHAIN="local"
export GOFLAGS="-buildvcs=false -trimpath"

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUST_BACKTRACE=1

export NODE_ENV="development"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# Python settings
export PYTHONDONTWRITEBYTECODE=1        # Prevent .pyc files
export PYTHONUNBUFFERED=1               # Disable output buffering
export PYTHONFAULTHANDLER=1             # Better tracebacks
export PYTHONHASHSEED=random            # Secure hash seeds

# Ruby Configuration
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_PATH="${GEM_HOME}:${XDG_DATA_HOME}/gem"
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"

###################
# Path Configuration
###################
# Add local bins to path if they exist
() {
    local -a paths=(
        "$HOME/.local/bin"
        "$GOBIN"
        "$CARGO_HOME/bin"
        "$HOME/.mise/bin"
        "${GEM_HOME}/bin"
    )

    for p in $paths; do
        if [[ -d "$p" ]]; then
            path=("$p" $path)
        fi
    done
}

# Clean up PATH
typeset -U PATH path
