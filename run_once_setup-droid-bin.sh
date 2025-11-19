#!/bin/bash
# Setup Droid bin directory with ripgrep symlink

if [ ! -d "$HOME/.factory/bin" ]; then
    mkdir -p "$HOME/.factory/bin"
fi

# Symlink system ripgrep to Droid's expected location
if command -v rg &> /dev/null && [ ! -e "$HOME/.factory/bin/rg" ]; then
    ln -sf "$(which rg)" "$HOME/.factory/bin/rg"
    echo "✓ Linked ripgrep to ~/.factory/bin/rg"
fi
