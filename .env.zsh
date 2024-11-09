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
# Terminal
export TERM="xterm-kitty"
export COLORTERM="truecolor"
export EDITOR="zed"
export VISUAL="zed"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Security
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$HOME/.ssh/agent"

# Performance
export MAKEFLAGS="-j$(nproc)"
export ZSTD_NBTHREADS=0
export CMAKE_GENERATOR="Ninja"

###################
# Development Environments
###################
# Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
fi

# Ruby
export RBENV_ROOT="$HOME/.rbenv"
[[ -d $RBENV_ROOT/bin ]] && path=($RBENV_ROOT/bin $path)
eval "$(rbenv init - zsh)"

# Node.js
export NODE_ENV="development"
export NPM_CONFIG_FUND=false
export NPM_CONFIG_AUDIT=false

# Rust
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUST_BACKTRACE=1
[[ -d $CARGO_HOME/bin ]] && path=($CARGO_HOME/bin $path)

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
[[ -d $GOBIN ]] && path=($GOBIN $path)

###################
# Tool Configuration
###################
# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --margin=1
    --padding=1
    --info=inline
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
"

# Docker/Kubernetes
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export KUBECONFIG="$HOME/.kube/config"
