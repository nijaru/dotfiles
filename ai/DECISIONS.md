# Dotfiles Decisions

Key architectural decisions and tool choices for this dotfiles configuration.

## Shell: Fish over Bash/Zsh

**Decision**: Use Fish shell as primary shell

**Rationale**:
- Superior out-of-box experience (syntax highlighting, autosuggestions, completions)
- Cleaner syntax for functions and conditionals
- Better scripting ergonomics for helper functions
- Active ecosystem (Fisher, Tide)
- Performance is comparable to other shells when optimized

**Trade-offs**:
- Non-POSIX (but we don't need POSIX compliance for interactive shell)
- Smaller community than Bash/Zsh
- Some tools default to Bash (handled via shebang)

## Prompt: Tide over Starship

**Decision**: Use Tide prompt, managed via Fisher

**Rationale**:
- Native Fish implementation (faster, no cross-process calls)
- Excellent performance (measured via hyperfine)
- Rich feature set for git, container contexts, languages
- Easy configuration via `tide configure`
- Fisher management enables easy updates

**Trade-offs**:
- Fish-only (but we chose Fish)
- Starship is more portable across shells (not a concern for us)

**Implementation**:
- Managed in `dot_config/fish/fish_plugins`
- Fisher handles installation (run_once_install-fisher.fish.tmpl)
- Vendored init disabled in favor of Fisher management

## Dotfile Management: chezmoi

**Decision**: Use chezmoi for dotfile management

**Rationale**:
- Cross-platform support (macOS + Fedora)
- Templating support for platform-specific configs
- Handles sensitive files (private_* encryption)
- Good tooling for drift detection
- Active development and community

**Trade-offs**:
- Learning curve for naming conventions (dot_*, private_*, _darwin/_linux suffixes)
- More complex than plain git repo
- Template syntax can be verbose

**Implementation**:
- Source in `~/.local/share/chezmoi/`
- Platform-specific suffixes for OS-specific files
- Templates for configs with dynamic values

## Version Management: mise over asdf

**Decision**: Use mise (formerly rtx)

**Rationale**:
- Rust-based, significantly faster than asdf
- Drop-in asdf replacement (same plugin ecosystem)
- Better ergonomics (`mise use` vs `asdf local`)
- Active development
- Works well with `@latest` pattern

**Trade-offs**:
- Newer tool, smaller community than asdf
- Some plugins may lag behind asdf versions

## Modern CLI Tools: Smart Fallbacks

**Decision**: Implement wrapper functions with fallbacks to standard tools

**Rationale**:
- Use modern tools when available (bat, eza, delta, btop, etc.)
- Graceful degradation to standard tools (cat, ls, diff, top)
- Works across different environments without breaking
- No brittleness from missing dependencies

**Implementation**:
- Functions in `dot_config/fish/functions/modern-cli/`
- Use `command_exists` helper to check availability
- Fallback to `command <original_tool>` when modern tool missing

**Example**:
```fish
function diff
    if command_exists delta
        command delta $argv
    else
        command diff $argv
    end
end
```

## Version Control: Git + jj

**Decision**: Keep both Git and Jujutsu (jj)

**Rationale**:
- Git is universal, required for most workflows
- jj provides better UX for local development (no staging area, better branching)
- jj can coexist with git (operates on git repos)
- Experimental adoption, keeping git as primary

**Trade-offs**:
- Maintaining two mental models
- jj is newer, ecosystem still developing
- Team workflows require git anyway

## Terminal: Ghostty

**Decision**: Use Ghostty as primary terminal

**Rationale**:
- GPU-accelerated, excellent performance
- Native macOS and Linux support
- Good font rendering
- Lightweight configuration

**Trade-offs**:
- Newer terminal, smaller ecosystem than iTerm2/Kitty/Alacritty
- Fewer plugins/extensions

## Editors: Zed (primary), Neovim (secondary)

**Decision**: Zed for primary work, Neovim for quick edits and remote

**Rationale**:
- Zed: Modern, fast, good LSP support, AI integration
- Neovim: Universal, works over SSH, powerful for text manipulation
- Both Rust-based, performant

**Trade-offs**:
- Maintaining two editor configs
- Zed is newer, smaller extension ecosystem
- Some workflows require terminal editor (Neovim)

## Rust Build Optimization

**Decision**: Add `~/.cargo/config.toml` with faster linker and build settings

**Rationale**:
- `cargo install` is slow by default
- Modern linkers (mold on Linux, lld on macOS) provide 2-5x speedup
- Parallel codegen units improve compile time
- Thin LTO balances compile time vs runtime performance

**Implementation**:
- Platform-specific linker config
- `codegen-units = 16` for faster compilation
- `lto = "thin"` for release builds
- Automatic CPU detection (`jobs = 0`)

**Trade-offs**:
- Slightly larger binary size
- Minimal runtime performance impact (acceptable for CLI tools)

## Package Management

**macOS**: Homebrew (Brewfile_darwin)
- Industry standard, excellent cask support
- Easy dependency management

**Fedora**: DNF + cargo + mise
- Native package manager for system packages
- cargo for Rust tools
- mise for language runtimes

## Fish Startup Optimization

**Decision**: Aggressive lazy-loading and caching for <30ms startup

**Rationale**:
- Target: <70ms (industry "good" baseline)
- Achieved: ~28ms (3.3x faster than initial 92ms)
- Fast shell = better developer experience across thousands of daily invocations

**Implementation**:
- `dev` function lazy-loads mise, docker, language abbrs on first project cd
- `__auto_load_dev` triggers on entering directories with .git, Cargo.toml, etc.
- Cache `uname` results in `__fish_uname` / `__fish_uname_m` (saves ~4ms)
- Cache `brew shellenv` to file, auto-invalidate when brew binary changes
- Disable unused vendor hooks (direnv, mise auto-activate)
- Fisher manages Tide (removed redundant run_once_setup-tide.fish.tmpl)

**Trade-offs**:
- First `dev` call has ~50ms cost
- Brew cache needs regeneration after significant brew changes (auto-handled)
- Slightly more complex config structure

## Portable SSH Config

**Decision**: Create `ssh-fish` command for SSH with temporary portable Fish config

**Rationale**:
- Use familiar Fish environment on random servers
- Don't require full dotfiles installation on every server
- Lightweight config transfers quickly (<5KB)
- Temporary - no trace left on remote servers
- Graceful fallback when Fish not available

**Implementation**:
- Portable config in `~/.config/fish/portable/config.fish`
- Minimal essentials: aliases, extract, mkcd, git shortcuts, simple prompt
- `ssh-fish` function:
  1. Creates temp dir on remote: `/tmp/.ssh-fish.XXXXXX`
  2. Syncs config (rsync preferred, tar+ssh fallback)
  3. Sources config with `--init-command`
  4. Auto-cleanup on exit via Fish event handler
- Checks for Fish availability before syncing

**Trade-offs**:
- SSH-only (Mosh uses SSH for handshake anyway)
- Explicit command (`ssh-fish`) vs automatic (opt-in behavior)
- Re-syncs every connection (but config is tiny, <5KB)
- Minimal config only (full dotfiles via chezmoi for owned servers)

## MCP Servers: Exa + Context7

**Decision**: Use Exa (search) and Context7 (docs) as only MCP servers

**Rationale**:
- Exa 2.1 outperforms other search APIs (Brave, Parallel) on both speed and quality
- Context7 provides library documentation lookup
- Fewer servers = less context overhead, simpler toolset
- Env var expansion buggy in Claude Code (GitHub #10955, #1254) - keys hardcoded at add time

**Implementation**:
- Claude Code: `claude mcp add` with `--env` flag (copies value at add time)
- Claude Desktop: chezmoi template with `.chezmoidata.yaml.age` decrypt
- Gemini CLI: `$EXA_API_KEY` in settings.json (runtime expansion works)
- `~/.claude.json` in `.chezmoiignore` (contains hardcoded keys)

**Trade-offs**:
- Claude Code keys need manual refresh after rotation
- Different key handling per tool (Claude Code bug workaround)

## Secrets Management: Age Encryption

**Decision**: Use chezmoi's age encryption for secrets

**Rationale**:
- Single encrypted file (`.chezmoidata.yaml.age`) for all secrets
- Decrypted at `chezmoi apply` time, injected into templates
- No plaintext secrets in git
- Works cross-platform

**Implementation**:
- Secrets in `.chezmoidata.yaml.age`
- Templates use `{{ $secrets := include ".chezmoidata.yaml.age" | decrypt | fromYaml }}`
- Fish secrets.fish.tmpl generates env vars at apply time

**Trade-offs**:
- Need age key on each machine
- Secrets in memory after apply (fish env vars)

## 2026-01-22: System Recovery

### Decision: Whitelisted Brewfile Cleanup
- **Context:** Fresh macOS install with many stale dependencies in `Brewfile_darwin`.
- **Decision:** Use a clean `Brewfile` as a whitelist and run `brew bundle cleanup --force`.
- **Rationale:** Minimize system bloat and ensure a reproducible, minimal environment.

### Decision: Rustup vs Mise
- **Context:** Evaluating Rust toolchain management.
- **Decision:** Stick with `rustup-init` for Rust specifically.
- **Rationale:** User preference for native Rustup management over Mise.

### Decision: New Age Key Generation
- **Context:** Original age key was lost in the system wipe.
- **Decision:** Generate a new key pair and re-encrypt secrets.
- **Rationale:** No backup of the original key existed; manual reconstruction of API keys is required.
