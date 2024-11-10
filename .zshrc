#!/usr/bin/env zsh
# Personal Zsh configuration file

###################
# Z4H Core Settings
###################
# Performance optimization: initialize Z4H immediately
(( ${+Z4H_BOOTSTRAPPING} )) || source ~/.zsh4humans/zsh4humans.zsh || return

# Basic configuration
zstyle ':z4h:' auto-update 'yes'
zstyle ':z4h:' auto-update-days 7
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:bindkey' keyboard 'pc'

# Performance tuning
zstyle ':z4h:' start-tmux 'no'              # Don't auto-start tmux
zstyle ':z4h:' prompt-height 1              # Minimize prompt height
zstyle ':z4h:*' term-vresize 'scroll'       # Faster terminal resizing
zstyle ':z4h:autosuggestions' delay 0.1     # Faster suggestions
zstyle ':z4h:compinit' arguments -C -i      # Faster compinit

# Feature configuration
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:direnv' enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'

# SSH configuration
zstyle ':z4h:ssh:*' enable 'no'
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh' '~/.aliases' '~/.linux'
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' extra-args -t 12h

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
# Initialize completion system
autoload -Uz compinit

# Load completions efficiently
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
    compinit -i
    { zcompile "${ZDOTDIR:-${HOME}}/.zcompdump" } &!
else
    compinit -C -i
fi

# Enhanced completion styling
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' group-name ''
zstyle ':completion:*' accept-exact '*(N)'   # Optimize path completion
zstyle ':completion:*' special-dirs true     # Complete special directories
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS

# Completion formatting
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

###################
# Core Configuration
###################
# Source core configurations
z4h source ~/.env.zsh
z4h source ~/.functions.zsh
z4h source ~/.cargo/env

# Function completions
compdef _git gbr=git-checkout
compdef _git git-clean=git-branch
compdef _docker dkstop-all=docker-stop
compdef _docker dkrm-all=docker-rm
compdef _docker dkclean=docker-system

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

###################
# Path Management
###################
# Add development tools to path
[[ -d $PYENV_ROOT/bin ]] && add_to_path "$PYENV_ROOT/bin"
[[ -d $CARGO_HOME/bin ]] && add_to_path "$CARGO_HOME/bin"
[[ -d $GOBIN ]] && add_to_path "$GOBIN"

# Final PATH cleanup
clean_path
