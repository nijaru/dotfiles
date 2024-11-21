#!/usr/bin/env zsh
# .env.zsh - Core environment configuration
# Defines base environment variables and paths used across the system

###################
# Environment Variables
###################
# Export essential environment variables directly
export EDITOR="zed"
export VISUAL="zed"
export ALTERNATE_EDITOR="nvim"
export MOAR="--style=catppuccin-mocha --quit-if-one-screen --no-statusbar --wrap"
export BAT_THEME="gruvbox-dark"

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
for dir in \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME" \
    "${XDG_CACHE_HOME}/zsh" \
    "${XDG_STATE_HOME}/less" \
    "${XDG_DATA_HOME}/gem" \
    "${XDG_CONFIG_HOME}/bundle"; do
    mkdir -p "$dir"
done

###################
# Tool Configuration
###################

# Development Tools Paths
export MISE_CONFIG_DIR="${XDG_CONFIG_HOME}/mise"
export MISE_DATA_DIR="${XDG_DATA_HOME}/mise"
export MISE_CACHE_DIR="${XDG_CACHE_HOME}/mise"

# Container Configuration
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Go Language Settings
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOTOOLCHAIN="local"
export GOFLAGS="-buildvcs=false -trimpath"

# Rust Language Settings
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUST_BACKTRACE=1

# Node.js Settings
export NODE_ENV="development"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# Python Settings
export PYTHONDONTWRITEBYTECODE=1 # Prevent .pyc files
export PYTHONUNBUFFERED=1        # Disable output buffering
export PYTHONFAULTHANDLER=1      # Better tracebacks
export PYTHONHASHSEED=random     # Secure hash seeds

# Ruby Configuration
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_PATH="${GEM_HOME}:${XDG_DATA_HOME}/gem"
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"

###################
# Environment Setup (Previously in .darwin.zsh, .linux.zsh, .env.zsh, etc.)
###################

# Development Environment Setup
case "$(uname -s)" in
Darwin)
    case "$(uname -m)" in
    arm64 | aarch64)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
    *)
        eval "$(/usr/local/bin/brew shellenv)"
        ;;
    esac
    ;;
esac
