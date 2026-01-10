#!/usr/bin/env fish
# Fish path configuration - optimized for performance
# Fish handles path deduplication automatically

# Only add paths in interactive shells or if not already set
if status is-interactive; or not set -q __paths_initialized
    # Batch add all paths at once to minimize operations
    # Only add paths that actually exist to avoid unnecessary checks
    set -l paths_to_add \
        $HOME/.local/share/mise/shims \
        $HOME/.local/bin \
        $HOME/bin \
        $HOME/go/bin \
        $HOME/.cargo/bin \
        $HOME/.mise/bin \
        $HOME/.modular/bin \
        $HOME/.pixi/bin \
        $HOME/.local/share/gem/bin \
        $HOME/.cache/.bun/bin

    for path in $paths_to_add
        test -d $path && fish_add_path -g $path
    end
    
    set -g __paths_initialized 1
end