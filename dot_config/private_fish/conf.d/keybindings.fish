#!/usr/bin/env fish
# Fish keyboard bindings

if status is-interactive
    # Enable default key bindings
    fish_default_key_bindings

    # Enable fzf key bindings if available
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end
    
    # Alt+E to open the current command line in the editor
    bind \ee edit_command_buffer
    
    # Alt+L for ls -la
    bind \el 'ls -la; commandline -f repaint'
    
    # Alt+G for git status
    bind \eg 'git status; commandline -f repaint'
end