#!/usr/bin/env fish
# Docker configuration for Fish shell
# Minimal abbrs - rely on fish completions instead

# Core shortcuts only
abbr --add d "docker"
abbr --add dc "docker compose"

# Docker functions are in functions/docker/
# - dksh.fish - Interactive container shell access
# - dklogs.fish - View container logs interactively
# - dkclean.fish - Clean up docker system
# - dkstats.fish - Show container resource usage
# - dkprune.fish - Remove unused containers, images, and volumes

# OrbStack init handled in config.fish
