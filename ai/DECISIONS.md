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
- Initial setup via `run_once_setup-tide.fish.tmpl`
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

**Decision**: Gate expensive operations to interactive shells only

**Rationale**:
- Scripts don't need completions or prompt
- Measured 30-50% startup improvement
- Better experience for one-off commands

**Implementation**:
- Wrap completions/prompt in `if status is-interactive`
- One-time completion generation via `run_once_*` scripts
- Lazy loading for expensive tools (GCP, etc.)
