#!/usr/bin/env fish
# Disable automatic activation of slow tools to improve startup performance

# Disable mise auto-activation from vendor_conf.d
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Disable direnv (not using .envrc files)
function _direnv_hook; end

# Cache uname results (called multiple times during startup)
set -g __fish_uname (command uname -s)
set -g __fish_uname_m (command uname -m)