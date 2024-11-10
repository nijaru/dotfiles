#!/usr/bin/env zsh
# Personal Zsh configuration file

###################
# Z4H Core Settings
###################
# Basic configuration
zstyle ':z4h:' auto-update 'yes'
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:bindkey' keyboard 'pc'

# Feature configuration
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:direnv' enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'

# Tmux integration
zstyle ':z4h:' start-tmux 'yes'
zstyle ':z4h:tmux:' auto-start 'no'
zstyle ':z4h:tmux:*' default-height '20'
zstyle ':z4h:tmux:*' mouse 'on'

# SSH configuration
zstyle ':z4h:ssh:*' enable 'no'
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh' '~/.aliases' '~/.linux'
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' extra-args -t 12h  # Reduced from 20h for better security

# Initialize Z4H
z4h init || return

###################
# History Settings
###################
HISTSIZE=1000000
SAVEHIST=1000000

setopt HIST_IGNORE_ALL_DUPS     # No duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_IGNORE_SPACE        # Ignore space-prefixed commands
setopt HIST_VERIFY              # Show before executing history commands
setopt SHARE_HISTORY            # Share history between shells
setopt EXTENDED_HISTORY         # Record timestamp of command

###################
# Completion System
###################
# Initialize completion
autoload -Uz compinit

# Ensure XDG cache directory exists
: "${XDG_CACHE_HOME:=$HOME/.cache}"
mkdir -p "$XDG_CACHE_HOME/zsh"

# Completion cache
local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
    compinit -d "$zcompdump"
    command rm -f "$zcompdump"(N.mh+24)
else
    compinit -C -d "$zcompdump"
fi

# Enhanced completion styling with fuzzy matching
zstyle ':completion:*' completer '_expand' '_complete' '_correct' '_approximate'
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/.zcompcache"

# Better completion groups
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

###################
# Tool Integration
###################
# Lazy loading function with caching
function lazy_load() {
    local load_cmd=$1
    local lazy_cmd=$2
    eval "function ${lazy_cmd}() {
        unfunction ${lazy_cmd}
        eval \"\$(${load_cmd})\"
        ${lazy_cmd} \"\$@\"
    }"
}

# Initialize tools
lazy_load 'zoxide init zsh' zoxide
lazy_load 'atuin init zsh' atuin
lazy_load 'direnv hook zsh' direnv
lazy_load 'pyenv init -' pyenv
lazy_load 'pyenv virtualenv-init -' pyenv-virtualenv
lazy_load 'rbenv init -' rbenv

###################
# Core Configuration
###################
# Source configurations in correct order
z4h source ~/.env.zsh
z4h source ~/.functions
z4h source ~/.cargo/env

# Function completions
function setup_function_completions() {
    # Git completions
    compdef _git gbr=git-checkout
    compdef _git git-clean=git-branch

    # Docker completions
    compdef _docker dkstop-all=docker-stop
    compdef _docker dkrm-all=docker-rm
    compdef _docker dkclean=docker-system

    # Project completions
    function _init_project() {
        local -a templates
        templates=($(ls ${PROJECT_TEMPLATE_DIR} 2>/dev/null))
        _describe 'template' templates
    }
    compdef _init_project init-project
}

# Call after compinit
setup_function_completions

###################
# Platform Specific
###################
# WSL support
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Load platform configurations
z4h source ~/.aliases
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    z4h source ~/.linux.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    z4h source ~/.darwin.zsh
fi

# Ensure PATH is clean
typeset -U PATH path
