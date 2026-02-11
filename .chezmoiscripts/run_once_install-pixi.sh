#!/bin/bash
# Install pixi via official installer
# Runs once per machine

if command -v pixi &> /dev/null; then
    echo "pixi already installed, skipping"
    exit 0
fi

echo "Installing pixi..."
PIXI_NO_PATH_UPDATE=1 curl -fsSL https://pixi.sh/install.sh | sh
