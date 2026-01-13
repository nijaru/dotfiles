#!/usr/bin/env fish
# Core environment configuration for Fish

# Core environment variables
set -gx EDITOR "zed"
set -gx VISUAL "zed"
set -gx GIT_EDITOR "zed --wait"  # Git needs blocking mode
set -gx ALTERNATE_EDITOR "nvim"
set -gx MOAR "--style=catppuccin-macchiato --quit-if-one-screen --no-statusbar --wrap"
set -gx BAT_THEME "Catppuccin Macchiato"

# XDG Base Directories
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
switch $__fish_uname
    case Darwin
        set -gx XDG_RUNTIME_DIR "$HOME/Library/Application Support/Ladybird"
    case '*'
        set -gx XDG_RUNTIME_DIR "/run/user/$UID"
end

# XDG directories are created by chezmoi run_once script

# Development Tools Paths
set -gx MISE_CONFIG_DIR "$XDG_CONFIG_HOME/mise"
set -gx MISE_DATA_DIR "$XDG_DATA_HOME/mise"
set -gx MISE_CACHE_DIR "$XDG_CACHE_HOME/mise"

# Container Configuration
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1

# Go Language Settings
set -gx GOPATH "$HOME/go"
set -gx GOBIN "$GOPATH/bin"
set -gx GOTOOLCHAIN "local"
set -gx GOFLAGS "-buildvcs=false -trimpath"

# Rust Language Settings
set -gx CARGO_HOME "$HOME/.cargo"
set -gx RUSTUP_HOME "$HOME/.rustup"
set -gx RUST_BACKTRACE 1

# Node.js Settings
set -gx NODE_ENV "development"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# OpenCode Settings
set -gx OPENCODE_EXPERIMENTAL_OXFMT true

# Python Settings
set -gx PYTHONDONTWRITEBYTECODE 1 # Prevent .pyc files
set -gx PYTHONUNBUFFERED 1        # Disable output buffering
set -gx PYTHONFAULTHANDLER 1      # Better tracebacks
set -gx PYTHONHASHSEED "random"   # Secure hash seeds

# Ruby Configuration
set -gx GEM_HOME "$XDG_DATA_HOME/gem"
set -gx GEM_PATH "$GEM_HOME:$XDG_DATA_HOME/gem"
set -gx BUNDLE_USER_HOME "$XDG_CONFIG_HOME/bundle"

# Modular
contains "$HOME/.modular/bin" $PATH; or set -gx PATH "$HOME/.modular/bin" $PATH

# Ripgrep configuration
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

# Platform-specific settings
switch $__fish_uname
    case Darwin
        # GPG Configuration
        set -gx GPG_TTY (tty)
        # CPU/Memory optimizations
        set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY "YES"
        # Container Configuration (Docker & OrbStack)
        set -gx DOCKER_HOST "unix://$HOME/.orbstack/run/docker.sock"
        set -gx DOCKER_DEFAULT_PLATFORM "linux/arm64"

        # Homebrew setup (cached, auto-invalidates on brew update)
        set -l brew_prefix (test $__fish_uname_m = arm64 && echo /opt/homebrew || echo /usr/local)
        set -l brew_cache "$XDG_CACHE_HOME/fish/brew_shellenv.fish"
        set -l brew_bin "$brew_prefix/bin/brew"
        # Invalidate cache if brew binary is newer than cache
        if not test -f $brew_cache; or test $brew_bin -nt $brew_cache
            $brew_bin shellenv > $brew_cache
        end
        source $brew_cache

        # Homebrew performance optimizations
        set -gx HOMEBREW_DOWNLOAD_CONCURRENCY "auto"  # Enable parallel downloads (4.6.0+)
        set -gx HOMEBREW_NO_AUTO_UPDATE 1              # Disable auto-update on install (update manually)
        set -gx HOMEBREW_NO_INSTALL_CLEANUP 1          # Skip cleanup during install (cleanup manually)
        set -gx HOMEBREW_NO_ENV_HINTS 1                # Reduce verbose output
        set -gx HOMEBREW_NO_ANALYTICS 1                # Disable analytics
        set -gx HOMEBREW_BOOTSNAP 1                    # Enable bootsnap for faster Ruby startup
end

# Load API keys (secrets.fish is NOT tracked by chezmoi)
if test -r $HOME/.config/fish/secrets.fish
    source $HOME/.config/fish/secrets.fish
end

# Path configuration is handled in conf.d/paths.fish
