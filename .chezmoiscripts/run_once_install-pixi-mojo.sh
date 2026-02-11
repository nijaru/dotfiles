#!/bin/bash
# Install Mojo globally via pixi (runs once per machine)

if ! command -v pixi &> /dev/null; then
    echo "pixi not found, skipping mojo install"
    exit 0
fi

if pixi global list 2>/dev/null | grep -q mojo; then
    echo "mojo already installed globally, skipping"
    exit 0
fi

echo "Installing mojo globally via pixi..."
pixi global install mojo -c https://conda.modular.com/max -c conda-forge
