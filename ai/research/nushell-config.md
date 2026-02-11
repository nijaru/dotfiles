# Nushell Configuration Research

**Date:** 2026-02-07
**Latest version:** 0.110.0 (released 2026-01-17)
**Key change:** env.nu is deprecated since 0.101 (Dec 2024). Use config.nu + autoload dirs.

## 1. File Structure and Loading Order

| Order | File                            | Purpose                                                  | Required |
| ----- | ------------------------------- | -------------------------------------------------------- | -------- |
| 1     | `env.nu`                        | Legacy env vars (deprecated, still loaded)               | No       |
| 2     | `config.nu`                     | Primary config: env vars, $env.config, commands, aliases | No       |
| 3     | `$nu.vendor-autoload-dirs/*.nu` | Vendor/package manager scripts (alphabetical)            | No       |
| 4     | `$nu.user-autoload-dirs/*.nu`   | User modular config (alphabetical)                       | No       |
| 5     | `login.nu`                      | Login shell only                                         | No       |

All files are optional. If missing, Nushell uses internal defaults. Errors in startup files do not prevent shell from starting.

## 2. Default Config Locations

| OS      | Path                                       | Override               |
| ------- | ------------------------------------------ | ---------------------- |
| macOS   | `~/Library/Application Support/nushell/`   | `$env.XDG_CONFIG_HOME` |
| Linux   | `~/.config/nushell/`                       | `$env.XDG_CONFIG_HOME` |
| Windows | `C:\Users\<user>\AppData\Roaming\nushell\` | `$env.XDG_CONFIG_HOME` |

Note: Set XDG to the parent directory, not the nushell subdirectory.

Autoload dirs:

- Vendor: `$nu.vendor-autoload-dirs` (typically `$nu.data-dir/vendor/autoload/`)
- User: `$nu.user-autoload-dirs`

Useful paths: `$nu.default-config-dir`, `$nu.config-path`, `$nu.env-path`, `$nu.data-dir`

## 3. Recommended config.nu for Experienced Developers

```nu
# config.nu -- only override what differs from defaults

# ── Basics ──────────────────────────────────────────────
$env.config.show_banner = false
$env.config.show_hints = false      # 0.110+ : disable completion/history hints
$env.config.buffer_editor = "zed --wait"

# ── History ─────────────────────────────────────────────
$env.config.history = {
    file_format: sqlite              # sqlite > plaintext (dedup, search)
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true                  # per-session history in REPL
}

# ── Completions ─────────────────────────────────────────
$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: fuzzy                 # fuzzy | prefix
    use_ls_colors: true
}

# ── Table display ───────────────────────────────────────
$env.config.table = {
    mode: rounded
    index_mode: auto
    show_empty: true
    padding: { left: 1, right: 1 }
    trim: {
        methodology: wrapping
        wrapping_try_keep_words: true
    }
    header_on_separator: false
}

# ── Errors (0.110+) ────────────────────────────────────
$env.config.error_style = "short"    # short | nested

# ── Hooks ───────────────────────────────────────────────
$env.config.hooks = {
    pre_prompt: []
    pre_execution: []
    env_change: {
        PWD: []
    }
}

# ── Filesize display ───────────────────────────────────
$env.config.filesize = {
    metric: false
    format: auto
}

# ── rm safety ──────────────────────────────────────────
$env.config.rm.always_trash = true
```

### Important: Override individual keys, never replace the whole record

```nu
# CORRECT
$env.config.show_banner = false

# WRONG -- obliterates all other settings
$env.config = { show_banner: false }
```

View all available options:

```nu
config nu --doc | nu-highlight | less -R
```

## 4. PATH and Environment Variables

### PATH management

```nu
# Append (lower precedence)
$env.PATH ++= ["~/.local/bin"]

# Prepend (higher precedence) -- preferred for dev tools
use std/util "path add"
path add "~/.local/bin"
path add ($env.CARGO_HOME? | default "~/.cargo" | path join "bin")
path add "~/.bun/bin"
```

$env is case-insensitive: `$env.PATH`, `$env.Path`, `$env.path` all work.

### Environment variables

```nu
# Direct assignment (in config.nu)
$env.EDITOR = "zed"
$env.VISUAL = "zed --wait"
$env.PAGER = "less -R"

# Batch load
load-env {
    EDITOR: "zed"
    VISUAL: "zed --wait"
}

# Check before access
$env.FOO? | default "fallback"

# Temporary (single command)
FOO=BAR some-command

# Remove
hide-env FOO
```

### NU_LIB_DIRS (for module resolution)

```nu
# Use const, not $env (the env version is deprecated)
const NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
    '~/nu-scripts'
]
```

## 5. Tool Integrations

### Starship prompt

Best method (vendor autoload, no config.nu edits needed):

```nu
# Run once (or in config.nu):
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
```

Manual method (in config.nu):

```nu
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "> "
$env.PROMPT_MULTILINE_INDICATOR = "::: "
```

Requires Nushell v0.96+.

### mise (runtime version manager)

Best method (vendor autoload):

```nu
# In config.nu (generates script, loaded automatically via vendor autoload):
mkdir ($nu.data-dir | path join "vendor/autoload")
^mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
```

Alternative (explicit source):

```nu
# In config.nu:
^mise activate nu | save -f ($nu.default-config-dir | path join "mise.nu")
source ($nu.default-config-dir | path join "mise.nu")
```

Known issue (Nov 2025): `mise activate nu` has emitted invalid code in some versions. If you see parser errors, use `--shims` as a workaround:

```nu
$env.PATH = ($env.PATH | prepend ($env.HOME | path join ".local/share/mise/shims"))
```

### Carapace (completions engine)

```nu
# In config.nu (or an autoload file):
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ($nu.cache-dir)
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/carapace.nu"
```

Note: carapace must be run before `source` -- put the generation step earlier in config.nu or in a separate autoload file that sorts before the source file.

### Zoxide

```nu
# In config.nu:
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
```

## 6. Breaking Changes Timeline

| Version | Date    | Change                                                                |
| ------- | ------- | --------------------------------------------------------------------- |
| 0.110.0 | 2026-01 | `$nu.temp-path` -> `$nu.temp-dir`, `$nu.home-path` -> `$nu.home-dir`  |
| 0.110.0 | 2026-01 | `*` no longer matches dotfiles in cp/mv/du (use `--all`)              |
| 0.110.0 | 2026-01 | New `show_hints` and `error_style` config options                     |
| 0.109.0 | 2025-11 | Source command fixes (regression fix in 0.109.1)                      |
| 0.106.0 | 2025-07 | Experimental options system introduced                                |
| 0.105.0 | 2025-06 | `where` subsumes `filter`; case-sensitive cell-paths                  |
| 0.101.0 | 2024-12 | env.nu deprecated; config simplification (override-only)              |
| 0.101.0 | 2024-12 | `$env.NU_LIB_DIRS` deprecated -> use `const NU_LIB_DIRS`              |
| 0.101.0 | 2024-12 | Theme vars replaced with `(dark-theme)` / `(light-theme)` from stdlib |
| 0.100.0 | 2024-11 | Major config overhaul: skeleton files, internal defaults              |

## 7. Migration Checklist (from pre-0.101)

1. Move everything from `env.nu` into `config.nu` (or autoload files)
2. Replace monolithic `$env.config = { ... }` with individual `$env.config.X = Y` lines
3. Replace `$env.NU_LIB_DIRS = [...]` with `const NU_LIB_DIRS = [...]`
4. Replace `$light_theme` / `$dark_theme` with `(dark-theme)` / `(light-theme)`
5. Move tool init scripts (starship, mise, carapace) to vendor autoload
6. Replace `$nu.temp-path` with `$nu.temp-dir` and `$nu.home-path` with `$nu.home-dir`
7. Use `config nu --doc` to discover all available settings

## 8. Recommended File Layout

```
~/.config/nushell/           # or ~/Library/Application Support/nushell/ on macOS
  config.nu                  # Main config (env vars, $env.config overrides, PATH)
  login.nu                   # Login-only setup (optional)
  env.nu                     # Empty or absent (deprecated)
  scripts/                   # Custom modules referenced by const NU_LIB_DIRS

~/.local/share/nushell/      # $nu.data-dir
  vendor/autoload/
    mise.nu                  # Generated by mise activate nu
    starship.nu              # Generated by starship init nu
    zoxide.nu                # Generated by zoxide init nushell
    carapace.nu              # Generated by carapace _carapace nushell
  history.sqlite3            # When using sqlite history
```

## Sources

- https://www.nushell.sh/book/configuration.html
- https://www.nushell.sh/book/environment.html
- https://www.nushell.sh/blog/2024-12-04-configuration_preview.html
- https://www.nushell.sh/blog/2026-01-17-nushell_v0_110_0.html
- https://github.com/nushell/nushell/discussions/14860
- https://mise.jdx.dev/cli/activate.html
- https://github.com/jdx/mise/discussions/4731
- https://carapace-sh.github.io/carapace-bin/setup.html
- https://starship.rs/guide/
