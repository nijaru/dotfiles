#!/usr/bin/env fish
# Disable automatic activation of slow tools to improve startup performance

# Disable mise auto-activation from vendor_conf.d
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Note: direnv from vendor_conf.d cannot be disabled via environment variable
# We'll provide lazy-loaded alternatives in dev.fish