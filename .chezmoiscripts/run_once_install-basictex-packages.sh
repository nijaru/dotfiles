#!/bin/bash
# Install BasicTeX tlmgr packages
# Runs once per machine after basictex is installed via Homebrew

if ! command -v tlmgr &> /dev/null; then
    echo "tlmgr not found, skipping (basictex may not be installed)"
    exit 0
fi

echo "Updating tlmgr and installing LaTeX packages..."
sudo tlmgr update --self
sudo tlmgr install titlesec marvosym enumitem hyperref fancyhdr babel-english xcolor geometry fontspec
