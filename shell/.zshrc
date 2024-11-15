#!/usr/bin/env zsh
# ~/.zshrc
# Core zsh configuration file optimized for zsh4humans framework

###################
# Initialization Check
###################
# Ensure we're running in zsh
if [[ ! -o interactive ]]; then
   return  # Exit if not running interactively
fi

# Ensure critical directories exist
() {
    local -a required_dirs=(
        "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
        "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
        "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
    )
    for dir in $required_dirs; do
        [[ -d "$dir" ]] || mkdir -p "$dir"
    done
}

###################
# Configuration Files
###################
# Core configuration files that should always exist
typeset -ga CORE_CONFIG_FILES=(
    '.env.zsh'          # Environment variables
    '.functions.zsh'    # Utility functions
    '.aliases.zsh'      # General aliases
    '.git.zsh'         # Git-specific aliases
    '.dev.zsh'         # Development tools
    '.docker.zsh'       # Docker configuration
    '.p10k.zsh'        # Prompt configuration
)

# Platform-specific configurations
typeset -ga PLATFORM_CONFIG_FILES=(
    '.darwin.zsh'       # macOS specific
    '.linux.zsh'        # Linux specific
)

# Optional local configurations
typeset -ga LOCAL_CONFIG_FILES
LOCAL_CONFIG_FILES=(
    '.zshrc.local'              # Machine-specific
    '.zshrc.company'            # Company-specific
    ".zshrc.${HOST}"           # Host-specific
    '.envrc'                   # Project-specific
)

###################
# Z4H Configuration
###################
# Performance settings
zstyle ':z4h:' auto-update 'yes'
zstyle ':z4h:' auto-update-days 7
zstyle ':z4h:' prompt-height 1              # Minimize prompt height
zstyle ':z4h:*' term-vresize 'scroll'       # Faster terminal resizing
zstyle ':z4h:autosuggestions' delay 0.1     # Faster suggestions
zstyle ':z4h:compinit' arguments -C -i      # Faster compinit

# Feature settings
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:bindkey' keyboard 'pc'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Development tools integration
zstyle ':z4h:direnv' enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'

# SSH configuration
zstyle ':z4h:ssh:*' enable 'no'
# Core shell configuration for remote sessions
zstyle ':z4h:ssh:*' send-extra-files ${^CORE_CONFIG_FILES} ${^PLATFORM_CONFIG_FILES}

# SSH agent configuration
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' extra-args -t 12h

# Initialize Z4H
z4h init || return

###################
# History Configuration
###################
() {
    local HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
    local HISTSIZE=1000000
    local SAVEHIST=1000000

    # Ensure history directory exists
    [[ -d "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" ]] || mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

    setopt HIST_IGNORE_ALL_DUPS     # No duplicate entries
    setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
    setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
    setopt HIST_IGNORE_SPACE        # Ignore space-prefixed commands
    setopt HIST_VERIFY              # Show before executing history commands
    setopt SHARE_HISTORY            # Share history between shells
    setopt EXTENDED_HISTORY         # Record timestamp of command
}

###################
# Completion System
###################
() {
    # Initialize completion system efficiently
    local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

    # Only regenerate zcompdump if it's older than 24 hours
    if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
        compinit -i -d "$zcompdump"
        { zcompile "$zcompdump" } &!
    else
        compinit -C -d "$zcompdump"
    fi

    # Completion styling
    zstyle ':completion:*' completer _expand _complete _correct _approximate
    zstyle ':completion:*' matcher-list '' \
        'm:{a-z\-}={A-Z\_}' \
        'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
        'r:|?=** m:{a-z\-}={A-Z\_}'

    # Completion behavior
    zstyle ':completion:*' menu select
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*' accept-exact '*(N)'
    zstyle ':completion:*' special-dirs true
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

    # Completion formatting
    zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
    zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
    zstyle ':completion:*:messages' format ' %F{purple}-- %d --%f'
    zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
}

###################
# Source Configuration Files
###################
# Safely source files with error checking
function safe_source() {
    local file=$1
    if [[ -f "$file" ]]; then
        source "$file"
    else
        # Get basename of file for comparison
        local basename=${file:t}

        # Show warning only for core and platform configs
        if (( ${CORE_CONFIG_FILES[(I)$basename]} + ${PLATFORM_CONFIG_FILES[(I)$basename]} )); then
            print -P "%F{yellow}Warning:%f Could not source ${file}" >&2
        fi
        return 1
    fi
}

# Define the order of loading explicitly
local -a config_files=(
    "$HOME/.env.zsh"        # Load environment variables first
    "$HOME/.functions.zsh"  # Then load functions
    "$HOME/.aliases.zsh"
    "$HOME/.git.zsh"
    "$HOME/.dev.zsh"
    "$HOME/.docker.zsh"
)

# Add platform-specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    config_files+=("$HOME/.linux.zsh")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    config_files+=("$HOME/.darwin.zsh")
fi

# Source configurations in order
for config in $config_files; do
    safe_source "$config"
done

# Then source local configurations if they exist
local -a local_configs=(
    ~/.local/zsh/*.zsh(N)  # Custom local configurations
)

# Add optional local configs
for config in $LOCAL_CONFIG_FILES; do
    # Expand any command substitutions in the filename
    local expanded_config=$(eval echo "$HOME/$config")
    local_configs+=("$expanded_config")
done

# Source local configurations
for config in $local_configs; do
    safe_source "$config"
done

###################
# Development Environment
###################
# Add development tools to path if they exist
() {
    local -a dev_paths=(
        "$PYENV_ROOT/bin"
        "$CARGO_HOME/bin"
        "$GOBIN"
    )

    for path_entry in $dev_paths; do
        [[ -d "$path_entry" ]] && path+=("$path_entry")
    done
}

###################
# Completion Setup
###################
# Function completions
compdef _git gbr=git-checkout
compdef _git git-clean=git-branch
compdef uv=python3

# WSL support
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

###################
# Performance Optimizations
###################
# Try to load zrecompile module, continue if not available
if zmodload zsh/zrecompile 2>/dev/null; then
    # Compile zsh files in background
    {
        local -a zsh_files=(
            ${ZDOTDIR:-$HOME}/.zshrc
            ${ZDOTDIR:-$HOME}/.zshenv
            ${ZDOTDIR:-$HOME}/.zprofile
            ~/.local/zsh/*.zsh(N-.)
        )

        for file in $zsh_files; do
            [[ -f "$file" ]] && zrecompile -pq "$file"
        done
    } &!
fi

# Final PATH cleanup using function from .functions.zsh
clean_path
