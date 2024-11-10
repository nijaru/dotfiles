#!/usr/bin/env zsh

###################
# Path Configuration
###################
typeset -U path PATH

path=(
    $HOME/.local/bin
    $HOME/bin
    $path
)

###################
# System Configuration
###################
# Editor Configuration
export EDITOR="zed"
export VISUAL="zed"
# Fallback chain: zed -> nvim -> vim
if command -v nvim >/dev/null 2>&1; then
    export ALTERNATE_EDITOR="nvim"
else
    export ALTERNATE_EDITOR="vim"
fi

# Terminal
export TERM="xterm-kitty"
export COLORTERM="truecolor"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Security
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$HOME/.ssh/agent"

# Performance
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
export ZSTD_NBTHREADS=0
export CMAKE_GENERATOR="Ninja"

###################
# Development Environments
###################
# Python
export PYTHONDONTWRITEBYTECODE=1    # No .pyc files
export PYTHONUNBUFFERED=1           # Real-time output
export PYTHONFAULTHANDLER=1         # Better tracebacks
export PYTHONHASHSEED=random        # Security
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)

# Node.js
export NODE_ENV="development"
export NPM_CONFIG_FUND=false
export NPM_CONFIG_AUDIT=false
export NPM_CONFIG_UPDATE_NOTIFIER=false  # Disable update notifications
[[ "$(uname -m)" == "arm64" ]] && export npm_config_arch="arm64"

# Rust
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUST_BACKTRACE=1
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export CARGO_INCREMENTAL=1
[[ -d $CARGO_HOME/bin ]] && path=($CARGO_HOME/bin $path)

###################
# Development Templates and Defaults
###################
# Project defaults
export VENV_PATH=".venv"
export PROJECT_TEMPLATE_DIR="$HOME/.project-templates"
export DEFAULT_PYTHON_VERSION="3.11"
export DEFAULT_NODE_VERSION="20"

# Development paths
export PROJECTS_DIR="$HOME/Projects"
export GITHUB_DIR="$HOME/github"

# Tool configurations for functions
export DOCKER_CLEAN_DAYS=7        # Days before docker cleanup
export PG_DATA_DIR="/opt/homebrew/var/postgresql@14"  # For pg functions

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOTOOLCHAIN="local"
export GOFLAGS="-buildvcs=false -trimpath"  # Added trimpath for reproducible builds
[[ -d $GOBIN ]] && path=($GOBIN $path)

###################
# Tool Configuration
###################
# Modern CLI Tools
export BAT_THEME="ayu-mirage"
export ATUIN_NOBIND="true"
export ZOXIDE_CMD_OVERRIDE="cd"
export BTOP_THEME="ayu-mirage"
export DUF_THEME="dark"

# FZF with Ayu Mirage colors (keeping your existing config as it's well-tuned)
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

# Less configuration
export LESS="-R --mouse --wheel-lines=3"
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# Development tools
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export KUBECONFIG="$HOME/.kube/config"
