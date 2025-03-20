#!/usr/bin/env fish
# Fish shell main configuration file

# Exit if not running interactively
status is-interactive || exit

# Source environment variables and other configs
if test -r $HOME/.config/fish/env.fish
    source $HOME/.config/fish/env.fish
else
    echo "Warning: Could not read file: $HOME/.config/fish/env.fish" >&2
end

# Source configuration files
set -l config_files \
    $HOME/.config/fish/functions.fish \
    $HOME/.config/fish/aliases.fish \
    $HOME/.config/fish/git.fish \
    $HOME/.config/fish/dev.fish \
    $HOME/.config/fish/docker.fish

# Platform-specific configuration
switch (uname -s)
    case Darwin
        set -a config_files $HOME/.config/fish/darwin.fish
    case Linux
        set -a config_files $HOME/.config/fish/linux.fish
end

# Source core configuration files
for file in $config_files
    if test -r $file
        source $file
    else
        echo "Warning: Could not read file: $file" >&2
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

# Initialize Starship prompt if available
if status is-interactive; and type -q starship
    starship init fish | source
end