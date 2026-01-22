#!/bin/bash
# Install rustup via official installer
# Runs once per machine

if command -v rustup &> /dev/null; then
    echo "rustup already installed, skipping"
    exit 0
fi

echo "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
