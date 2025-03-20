#!/usr/bin/env fish
# Core utility functions for Fish shell

# NOTE: Individual function definitions have been moved to the functions/ directory
# for proper Fish autoloading. This file is kept for reference only.

# Functions are now organized into subdirectories by category:
#
# - editor/      - Editor-related functions (e.fish, v.fish, hx.fish, etc.)
# - fs/          - Filesystem operations (mkd.fish, rmrf.fish, extract.fish, etc.)
# - git/         - Git operations
# - homebrew/    - Homebrew operations
# - kubernetes/  - Kubernetes operations
# - modern-cli/  - Modern CLI replacement tools (ls.fish, cat.fish, etc.)
# - navigation/  - Directory navigation
# - utils/       - Utility functions
# - docker/      - Docker operations

# Editor Functions (editor/):
# - e.fish - Edit files with $EDITOR and auto-create directories
# - e_dot.fish, z_dot.fish, v_dot.fish, c_dot.fish - Open current directory in different editors
# - v.fish - Edit with Neovim
# - z.fish, zp.fish - Edit with Zed
# - hx.fish - Edit with Helix
# - c.fish - Edit with VS Code

# Filesystem Functions (fs/):
# - t.fish - Touch files (create empty files)
# - mkd.fish - Create directories with parents
# - rmd.fish - Remove directories
# - rmrf.fish - Force remove files/directories
# - mkcd.fish - Create and cd into directory
# - cpv.fish - Copy with progress
# - mvv.fish - Move with progress
# - symlink.fish - Create symbolic links
# - compress.fish - Compress files into various formats
# - extract.fish - Extract various archive formats
# - tmpd.fish - Create and cd to temporary directory
# - flac2wav.fish - Convert FLAC to WAV
# - ef.fish - Restart fish shell

# Modern CLI Replacements (modern-cli/):
# - ls.fish, l.fish, ll.fish, la.fish, etc. - Enhanced directory listing
# - cat.fish - Enhanced file viewing with syntax highlighting
# - less.fish - Enhanced pager
# - grep.fish - Enhanced text search
# - find.fish - Enhanced file search
# - tree.fish, lt.fish, llt.fish - Tree view directory listings
# - df.fish - Enhanced disk usage display
# - du.fish - Enhanced disk usage analysis
# - ps.fish - Enhanced process listing
# - top.fish - Enhanced system monitoring
# - diff.fish - Enhanced file comparison
# - dig.fish - Enhanced DNS lookup
# - ping.fish - Graphical ping
# - preview.fish - FZF file preview
# - hypf.fish - Benchmark commands

# Navigation Functions (navigation/):
# - prev.fish - Go to previous directory (cd -)
# - cdf.fish - Change to directory of given file
# - d.fish - Show directory stack
# - dl.fish - Go to Downloads directory
# - doc.fish - Go to Documents directory
# - dt.fish - Go to Desktop directory
# - p.fish - Go to Projects directory
# - ghub.fish - Go to GitHub directory

# Utility Functions (utils/):
# - command_exists.fish - Check if command exists
# - edit_with_mkdir.fish - Helper for editor functions
# - genpass.fish - Generate secure password
# - jsonf.fish - Format JSON
# - randstr.fish - Generate random string
# - timecmd.fish - Time command execution
# - uuid.fish - Generate UUID
# - calc.fish - Simple calculator
# - aoc-input.fish - Download Advent of Code input

# Homebrew Functions (homebrew/):
# - brews.fish - Search Homebrew packages
# - brewin.fish - Show Homebrew package info
# - brewi.fish - Install Homebrew package
# - brewu.fish - Update Homebrew and upgrade packages
# - brewx.fish - Uninstall Homebrew package
# - brewl.fish - List installed Homebrew packages
# - brewc.fish - Clean up Homebrew cache
# - up.fish - Alias for brewu (update all)
# - casks.fish, caskin.fish, caski.fish, caskx.fish, caskl.fish - Homebrew Cask commands

# Docker Functions (docker/):
# - dksh.fish - Interactive container shell access
# - dklogs.fish - View container logs interactively  
# - dkclean.fish - Clean up docker system
# - dkstats.fish - Show container resource usage
# - dkprune.fish - Remove unused containers, images, and volumes

# Kubernetes Functions (kubernetes/):
# - kns.fish - Set Kubernetes namespace
# - kctx.fish - Set Kubernetes context
# - kpods.fish - List Kubernetes pods
# - klogs.fish - Get Kubernetes pod logs

# Git Functions (git/):
# - git_current_branch.fish - Get current branch name
# - gpsuob.fish - Push current branch and set upstream
# - gswitch.fish - Interactive branch switching
# - git-clean.fish - Clean up merged branches
# - git-prune.fish - Prune remote branches and tags
# - gadd.fish - Interactive git add with diff preview