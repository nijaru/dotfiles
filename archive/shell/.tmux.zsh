# ~/.tmux.zsh

###################
# zsh4humans Tmux Configuration
###################

# Enable tmux integration
zstyle ':z4h:' start-tmux 'yes'
zstyle ':z4h:tmux:*' auto-start 'yes'

# Core Settings
zstyle ':z4h:tmux:*' command 'tmux -u new -A -D -t z4h'       # Base tmux command
zstyle ':z4h:tmux:*' extra-opts '-f ~/.config/tmux/tmux.conf' # Config file location
zstyle ':z4h:tmux:*' session-name 'main'                      # Default session name

# Appearance
zstyle ':z4h:tmux:*' status-position 'top'          # Status bar position
zstyle ':z4h:tmux:*' status-style 'bg=black'        # Status bar style
zstyle ':z4h:tmux:*' terminal-overrides 'xterm*:Tc' # Terminal capabilities

# Window Management
zstyle ':z4h:tmux:*' base-index 1           # Start window numbering at 1
zstyle ':z4h:tmux:*' pane-base-index 1      # Start pane numbering at 1
zstyle ':z4h:tmux:*' renumber-windows 'on'  # Renumber windows when closing
zstyle ':z4h:tmux:*' aggressive-resize 'on' # Aggressive window resizing

# Mouse and Keyboard
zstyle ':z4h:tmux:*' mouse 'on'     # Enable mouse support
zstyle ':z4h:tmux:*' mode-keys 'vi' # Vi mode keys

# Environment Variables to Update
zstyle ':z4h:tmux:*' update-environment 'DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY'

# Copy Mode Integration
if [[ "$OSTYPE" == "darwin"* ]]; then
    zstyle ':z4h:tmux:*' copy-command 'pbcopy'
elif command -v wl-copy >/dev/null 2>&1; then
    # Wayland
    zstyle ':z4h:tmux:*' copy-command 'wl-copy'
elif command -v xclip >/dev/null 2>&1; then
    zstyle ':z4h:tmux:*' copy-command 'xclip -in -selection clipboard'
elif command -v xsel >/dev/null 2>&1; then
    zstyle ':z4h:tmux:*' copy-command 'xsel -i --clipboard'
fi

# SSH Integration
zstyle ':z4h:tmux:ssh:*' enable 'yes'        # Enable SSH integration
zstyle ':z4h:tmux:ssh:*' forward-agent 'yes' # Forward SSH agent
