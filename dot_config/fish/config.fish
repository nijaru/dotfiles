#!/usr/bin/env fish
# Fish shell main configuration file

# Exit if not running interactively
status is-interactive || exit

# Fish shell main configuration

# Source environment variables and other configs
if test -r $HOME/.config/fish/env.fish
    source $HOME/.config/fish/env.fish
else
    echo "Warning: Could not read file: $HOME/.config/fish/env.fish" >&2
end

# Source only essential configuration files at startup
# Heavy development tools are lazy-loaded
set -l essential_configs \
    $HOME/.config/fish/editor.fish

# Platform-specific configuration
switch (uname -s)
    case Darwin
        set -a essential_configs $HOME/.config/fish/darwin.fish
    case Linux
        set -a essential_configs $HOME/.config/fish/linux.fish
end

# Source essential configs only
for file in $essential_configs
    test -r $file && source $file
end

# Lazy-load development environment on demand
function dev
    if not set -q __dev_loaded
        test -r $HOME/.config/fish/dev.fish && source $HOME/.config/fish/dev.fish
        test -r $HOME/.config/fish/docker.fish && source $HOME/.config/fish/docker.fish
        set -g __dev_loaded 1
        echo "Development environment loaded"
    end
end

# Auto-load dev tools when entering project directories
function __auto_load_dev --on-variable PWD
    # Common project indicators
    if test -f package.json -o -f go.mod -o -f Cargo.toml -o -f Gemfile -o -f pyproject.toml -o -f requirements.txt -o -d .git
        if not set -q __dev_loaded
            dev >/dev/null 2>&1
        end
    end
end

# Setup Fish shell features (equivalent to some Z4H features)
# Enable Fish's built-in completion and highlighting
# Note: Most Z4H features have Fish equivalents built in

# Initialize Fish colors for a nice prompt
set -g fish_color_normal normal
set -g fish_color_command blue
set -g fish_color_param cyan
set -g fish_color_redirection yellow
set -g fish_color_end green
set -g fish_color_error red
set -g fish_color_comment brblack
set -g fish_color_match --background=brblue
set -g fish_color_search_match --background=brblack
set -g fish_color_operator yellow
set -g fish_color_escape magenta
set -g fish_color_cwd green
set -g fish_color_autosuggestion brblack
set -g fish_color_user brgreen
set -g fish_color_host normal
set -g fish_color_host_remote yellow
set -g fish_color_cancel -r

# Enable modern features
set -g fish_key_bindings fish_default_key_bindings  # Default key bindings

# SSH-aware configuration
if status is-interactive
    # Completely clear universal variable to prevent conflicts
    set -e -U tide_prompt_transient_enabled 2>/dev/null
    # SSH-specific settings
    if set -q SSH_CLIENT; or set -q SSH_TTY
        # Fix terminal type for SSH sessions (enables clear/Ctrl-L)
        set -gx TERM xterm-256color
        # Disable transient prompts over SSH (session variable)
        set -g tide_prompt_transient_enabled false
    else
        # Enable transient prompts locally (session variable)
        set -g tide_prompt_transient_enabled true
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
