#!/usr/bin/env fish
# Fish path configuration - single source of truth
# Priority: last added = highest (fish_add_path prepends by default)

if status is-interactive; or not set -q __paths_initialized
    set -l paths_to_add \
        $HOME/.local/share/mise/shims \
        $HOME/.local/bin \
        $HOME/.cargo/bin \
        $HOME/.pixi/bin \
        $HOME/.cache/.bun/bin

    for path in $paths_to_add
        test -d $path && fish_add_path -g $path
    end

    set -g __paths_initialized 1
end