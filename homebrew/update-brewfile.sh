#!/usr/bin/env bash
# Update Brewfile with currently installed packages

set -e

cd "$(dirname "$0")"
echo "Updating Brewfile with currently installed packages..."
brew bundle dump --force
echo "✅ Brewfile updated successfully"