#!/usr/bin/env zsh

###################
# XDG Base Directories
###################
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

###################
# Shell Configuration
###################
# ZSH specific
export ZDOTDIR="${ZDOTDIR:-$HOME}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# History configuration
export HISTFILE="${ZDOTDIR}/.zsh_history"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

###################
# Editor & Tools
###################
# Default editors
export EDITOR="zed"
export VISUAL="zed"
export ALTERNATE_EDITOR="nvim"

# Tool configurations
export PAGER="less"
export LESS="-R --mouse --wheel-lines=3"
export BAT_THEME="ayu-mirage"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

###################
# Development Environment
###################
# Python
export PYTHONDONTWRITEBYTECODE=1    # No .pyc files
export PYTHONUNBUFFERED=1           # Real-time output
export PYTHONFAULTHANDLER=1         # Better tracebacks
export PYTHONHASHSEED=random        # Security
export PYENV_ROOT="$HOME/.pyenv"

# Node.js
export NODE_ENV="development"
export NPM_CONFIG_FUND=false        # Disable funding messages
export NPM_CONFIG_AUDIT=false       # Disable audit messages
export NPM_CONFIG_UPDATE_NOTIFIER=false
[[ "$(uname -m)" == "arm64" ]] && export npm_config_arch="arm64"

# Rust
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUST_BACKTRACE=1
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export CARGO_INCREMENTAL=1

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOTOOLCHAIN="local"
export GOFLAGS="-buildvcs=false -trimpath"

###################
# Performance Settings
###################
# CPU/Memory optimizations
if [[ "$(uname -m)" == "arm64" ]]; then
    export MAKEFLAGS="-j$(sysctl -n hw.perflevel0.logicalcpu)"
    # Optimize for M1/M2 chips
    export CFLAGS="-O2 -pipe -march=native"
    export CXXFLAGS="${CFLAGS}"
else
    export MAKEFLAGS="-j$(nproc)"
    # Generic x86_64 optimizations
    export CFLAGS="-O2 -pipe"
    export CXXFLAGS="${CFLAGS}"
fi

###################
# Security & Privacy
###################
# SSH configuration
export SSH_AUTH_SOCK="$HOME/.ssh/agent"
export GPG_TTY=$(tty)

###################
# Tool Integration
###################
# Modern CLI tools
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --margin=1
    --padding=1
    --info=inline
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --preview-window=right:60%
    --color=fg:#E6E1CF,bg:#1F2430,hl:#FF9940
    --color=fg+:#E6E1CF,bg+:#232834,hl+:#FF9940
    --color=info:#95E6CB,prompt:#6994BF,pointer:#FF9940
    --color=marker:#73D0FF,spinner:#73D0FF,header:#73D0FF
"

# Ensure cache directories exist
mkdir -p "${XDG_CACHE_HOME}/zsh"
mkdir -p "${XDG_STATE_HOME}/less"
