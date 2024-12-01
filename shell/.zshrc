#!/usr/bin/env zsh
# ~/.zshrc

###################
# Initialization Check
###################
# Exit if not running interactively
[[ -o interactive ]] || return

###################
# Source Environment Variables
###################
# Core environment variables
if [[ -r $HOME/.env.zsh ]]; then
    source $HOME/.env.zsh
else
    print -P "%F{yellow}Warning:%f Could not read file: $HOME/.env.zsh" >&2
fi

# Platform-specific environment variables
case "$OSTYPE" in
darwin*)
    # GPG Configuration
    export GPG_TTY=$(tty)
    # CPU/Memory optimizations
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # Better fork performance
    # Container Configuration (Docker & OrbStack)
    export DOCKER_HOST="unix://$HOME/.orbstack/run/docker.sock"
    export DOCKER_DEFAULT_PLATFORM="linux/arm64"
    # Homebrew Settings
    # Core behavior
    zstyle ':z4h:brew:*' auto-update no
    zstyle ':z4h:brew:*' analytics no
    zstyle ':z4h:brew:*' auto-cleanup yes
    zstyle ':z4h:brew:*' parallel-jobs "$(sysctl -n hw.ncpu)"
    zstyle ':z4h:brew:*' bottle-source-fallback no
    # Security
    zstyle ':z4h:homebrew' secure-redirect yes # Prevent insecure redirects
    zstyle ':z4h:homebrew' require-sha yes     # Require SHA verification for casks
    zstyle ':z4h:homebrew' force-brewed-curl yes
    zstyle ':z4h:homebrew' curl-retries 3 # More resilient downloads
    # UI/UX
    zstyle ':z4h:homebrew' env-hints no
    zstyle ':z4h:homebrew' bat yes
    ;;
linux*)
    # linux specific environment variables
    ;;
esac

###################
# Path Configuration
###################
typeset -gU path
path=(
    $HOME/.local/bin
    $GOBIN
    $CARGO_HOME/bin
    $HOME/.mise/bin
    ${GEM_HOME}/bin
    $HOME/.modular/bin
    $path
)

###################
# Configuration Files
###################
# Core configuration files
typeset -ga Z4H_CORE_FILES=(
    $HOME/.env.zsh
    $HOME/.functions.zsh
    $HOME/.aliases.zsh
    $HOME/.git.zsh
    $HOME/.dev.zsh
    $HOME/.docker.zsh
    $HOME/.p10k.zsh
    # $HOME/.tmux.zsh
)

# Platform-specific configuration
case "$(uname -s)" in
Darwin)
    Z4H_CORE_FILES+=($HOME/.darwin.zsh)
    ;;
Linux)
    Z4H_CORE_FILES+=($HOME/.linux.zsh)
    ;;
esac

# Optional local configurations
# typeset -ga Z4H_LOCAL_FILES=(
#     $HOME/.local/zsh/*.zsh(N)
#     $HOME/.zshrc.local(N)
#     $HOME/.zshrc.company(N)
#     $HOME/.zshrc.$HOST(N)
#     $PWD/.envrc(N)
# )

###################
# Z4H Core Configuration
###################
# Auto-update and core settings
zstyle ':z4h:' auto-update yes
zstyle ':z4h:' auto-update-days 7

# Terminal and UI
zstyle ':z4h:' prompt-height 1
zstyle ':z4h:' prompt-at-bottom no
zstyle ':z4h:' term-shell-integration yes
zstyle ':z4h:*' term-vresize scroll
zstyle ':z4h:*' use-path-helper yes
zstyle ':z4h:*' pager 'moar'
zstyle ':z4h:term:*' underline-urls yes
zstyle ':z4h:term:*' mouse yes

# Clipboard Integration
zstyle ':z4h:*' propagate-clipboard yes

# FZF Configuration
zstyle ':z4h:fzf' command 'fd --type f --hidden --follow --exclude .git'
zstyle ':z4h:fzf' flags \
    '--preview="bat \
        --style=numbers \
        --color=always \
        --line-range :500 {}"'

# Performance settings
zstyle ':z4h:autosuggestions' delay 0.1
zstyle ':z4h:autosuggestions' forward-char accept
zstyle ':z4h:compinit' arguments -C -i

# Development tools integration
zstyle ':z4h:direnv' enable yes
zstyle ':z4h:direnv:success' notify yes

# SSH Configuration
zstyle ':z4h:ssh:*' enable yes
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' lifetime '7d'
zstyle ':z4h:ssh-agent:' identities '~/.ssh/id_ed25519'
zstyle ':z4h:ssh-agent:' extra-args --apple-use-keychain

# SSH Forwarding
zstyle ':z4h:ssh:*' send-extra-files yes
zstyle ':z4h:ssh:*' copy-identity yes
zstyle ':z4h:ssh:*' forward-files $HOME/.zshrc $Z4H_CORE_FILES

# GPG
zstyle ':z4h:gpg-agent' start 'yes'

# Tmux Configuration
zstyle ':z4h:' start-tmux 'no'

###################
# Initialize Z4H
###################
z4h init || return

###################
# Source Configuration Files
###################
# Source core configuration files with compilation
for file in $Z4H_CORE_FILES; do
    if [[ -r $file ]]; then
        z4h source -c $file
    else
        print -P "%F{yellow}Warning:%f Could not read file: $file" >&2
    fi
done

# Source local configurations with compilation
# for file in $Z4H_LOCAL_FILES; do
#     if [[ -r $file ]]; then
#         z4h source -c $file
#     else
#         print -P "%F{yellow}Warning:%f Could not read file: $file" >&2
#     fi
# done

###################
# Completion Setup
###################
# Initialize completions
z4h compile ${Z4H_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump}

# Setup 'magic' command completion if available
if command -v magic >/dev/null 2>&1; then
    z4h source <(magic completion --shell zsh)
fi

# Custom compdef mappings
compdef uv=python3
compdef eza=ls

###################
# WSL Support
###################
if [[ (-f /proc/version && "$(</proc/version)" == *microsoft*) || -n "$WSL_DISTRO_NAME" ]]; then
    [[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home
fi
