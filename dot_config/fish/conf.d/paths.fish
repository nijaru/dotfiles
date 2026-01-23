#!/usr/bin/env fish
# Fish path configuration - single source of truth
# Priority: last added = highest (fish_add_path prepends by default)

if status is-interactive; or not set -q __paths_initialized
    set -l paths_to_add \
        $HOME/.local/bin \
        $HOME/.modular/bin \
        $HOME/.pixi/bin \
        $HOME/.local/share/gem/bin \
        $HOME/go/bin \
        $HOME/.cargo/bin \
        $HOME/.cache/.bun/bin \
        $HOME/.local/share/mise/shims

    for path in $paths_to_add
        test -d $path && fish_add_path -g $path
    end

    set -g __paths_initialized 1
end