# Personal Zsh configuration file.
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Z4H Configuration
zstyle ':z4h:' auto-update      'no'
zstyle ':z4h:bindkey' keyboard  'pc'
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:direnv'         enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'
zstyle ':z4h:ssh:*'         enable 'no'
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh' '~/.aliases' '~/.linux'
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' extra-args -t 20h

# Initialize Z4H
z4h init || return

# Source configurations
z4h source ~/.env.zsh
z4h source ~/.cargo/env

# Kitty shell integration
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

# Key bindings
z4h bindkey undo Ctrl+/   Shift+Tab
z4h bindkey redo Option+/
z4h bindkey z4h-cd-back    Shift+Left
z4h bindkey z4h-cd-forward Shift+Right
z4h bindkey z4h-cd-up      Shift+Up
z4h bindkey z4h-cd-down    Shift+Down

# Homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# Functions and completions
autoload -Uz zmv compinit
compinit

compdef _directories md

# WSL support
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Source aliases and platform-specific configs
z4h source ~/.functions
z4h source ~/.aliases
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  z4h source ~/.linux.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  z4h source ~/.darwin.zsh
fi

# Update alias
alias up="${aliases[up]:-up}; rustup update; pipx upgrade-all; z4h update"

# Shell options
setopt glob_dots
setopt no_auto_menu
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
