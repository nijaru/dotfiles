#!/usr/bin/env fish
# Core utility functions for Fish shell

# NOTE: Individual function definitions have been moved to the functions/ directory
# for proper Fish autoloading. This file is kept for reference only.

# Functions now available in individual files:
# - aoc-input.fish - Download Advent of Code input
# - edit_with_mkdir.fish - Open editor with automatic directory creation
# - extract.fish - Extract various archive formats
# - mkcd.fish - Create and enter directory
# - command_exists.fish - Check if a command exists
# - and many more editor, file, git, docker, and system utility functions
#
# Homebrew functions available in individual files:
# - brews.fish - Search Homebrew packages
# - brewin.fish - Show Homebrew package info
# - brewi.fish - Install Homebrew package
# - brewu.fish - Update Homebrew and upgrade packages
# - brewx.fish - Uninstall Homebrew package
# - brewl.fish - List installed Homebrew packages
# - brewc.fish - Clean up Homebrew cache
# - up.fish - Alias for brewu (update all)
# - casks.fish, caskin.fish, caski.fish, caskx.fish - Homebrew Cask commands

# Docker/Kubernetes functions available in individual files:
# - dksh.fish - Interactive container shell access
# - dklogs.fish - View container logs interactively  
# - dkclean.fish - Clean up docker system
# - dkstats.fish - Show container resource usage
# - dkprune.fish - Remove unused containers, images, and volumes
# - kns.fish, kctx.fish, kpods.fish, klogs.fish - Kubernetes functionality

# Git functions available in individual files:
# - git_current_branch.fish - Get current branch name
# - gpsuob.fish - Push current branch and set upstream
# - gswitch.fish - Interactive branch switching
# - git-clean.fish - Clean up merged branches
# - git-prune.fish - Prune remote branches and tags
# - gadd.fish - Interactive git add with diff preview