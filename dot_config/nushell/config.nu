# config.nu — Nushell configuration (companion shell)

# ── Settings ────────────────────────────────────────────
$env.config.show_banner = false
$env.config.buffer_editor = "zed --wait"
$env.config.rm.always_trash = true
$env.config.error_style = "short"

$env.config.history = {
    file_format: sqlite
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true
}

$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.use_ls_colors = true

$env.config.table.mode = "compact"
$env.config.table.index_mode = "auto"
$env.config.table.show_empty = true
$env.config.table.padding = { left: 1, right: 1 }
$env.config.table.trim = { methodology: wrapping, wrapping_try_keep_words: true }

# ── Environment ─────────────────────────────────────────
$env.EDITOR = "zed"
$env.VISUAL = "zed --wait"
$env.BAT_THEME = "Catppuccin Macchiato"

$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local/state")

$env.PYTHONDONTWRITEBYTECODE = 1
$env.PYTHONUNBUFFERED = 1
$env.PYTHONFAULTHANDLER = 1

$env.GOPATH = ($env.HOME | path join "go")
$env.GOBIN = ($env.GOPATH | path join "bin")
$env.GOTOOLCHAIN = "local"
$env.GOFLAGS = "-buildvcs=false -trimpath"

$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.RUSTUP_HOME = ($env.HOME | path join ".rustup")
$env.RUST_BACKTRACE = 1

# ── PATH ────────────────────────────────────────────────
use std/util "path add"
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".modular/bin")
path add ($env.HOME | path join ".pixi/bin")
path add ($env.HOME | path join ".local/share/gem/bin")
path add ($env.HOME | path join "go/bin")
path add ($env.HOME | path join ".cargo/bin")
path add ($env.HOME | path join ".cache/.bun/bin")
path add ($env.HOME | path join ".local/share/mise/shims")

# ── Aliases ─────────────────────────────────────────────
alias ll = ls -l
alias la = ls -a

# ── Vendor Autoload Bootstrap ───────────────────────────
# Integration scripts are generated once, then auto-sourced on startup.
# Regenerate with: rm ($nu.data-dir | path join "vendor/autoload/*.nu")
let vendor_dir = ($nu.data-dir | path join "vendor/autoload")
if not ($vendor_dir | path exists) { mkdir $vendor_dir }

if (which zoxide | is-not-empty) {
    let zoxide_init = ($vendor_dir | path join "zoxide.nu")
    if not ($zoxide_init | path exists) {
        zoxide init nushell | save -f $zoxide_init
    }
}
