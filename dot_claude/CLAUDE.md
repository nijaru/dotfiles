# Personal Preferences & Workflows

## Git Preferences
- **NO AI attribution** - Never add "🤖 Generated with Claude" or similar to commits/PRs
- **STRIP attribution** - Remove any AI attribution found in existing commits/code
- **No auto PR** - Never open pull requests without explicit permission
- **No auto push** - Always ask before pushing to remote
- **Commit format**: `type: description` (feat, fix, docs, refactor, test, chore)

## Code Comment Philosophy

**Default**: Most code needs NO comments. Well-structured code is self-documenting.

### ✅ GOOD Comments (Rare but Valuable)
- **WHY decisions**: `# Use 1000 threshold - benchmarks show 3x speedup`
- **Non-obvious requirements**: `# EU GDPR requires 7-year retention`
- **Complexity notes**: `# O(n log n) despite linear scan - sorting dominates`
- **External workarounds**: `# Workaround: Library X lacks feature Y`
- **Algorithm rationale**: `# Quickselect over sort - only need top K`

### ❌ BAD Comments (Never Add These)
- **WHAT code does**: `# Increment counter` (obvious from code)
- **Narrative/emotional**: `# CRITICAL FIX!` `# This works perfectly!`
- **Debugging breadcrumbs**: `# TODO: Fix this` (remove before commit)
- **Syntax explanation**: `# Convert to global ID` (use better variable names)
- **Stating the obvious**: `# Update size` for `size += count`

### 📏 Comment Litmus Test
Before adding ANY comment, ask:
1. Does this explain WHY, not WHAT?
2. Will this be valuable in 6 months?
3. Can better naming eliminate this comment?

**Example**: Instead of commenting, use clear names:
```python
# Bad: Comment needed
id = s * c + l  # Calculate global ID

# Good: Self-documenting
global_id = segment_id * segment_capacity + local_node_id
```

## Python Development (Personal Stack)

### Toolchain: uv + mise
```bash
# New project
mise install python@latest && mise use python@latest
uv init && uv sync

# Add dependencies
uv add [packages]              # Never use pip install
uv add --dev [dev-packages]    # Dev dependencies

# Run code
uv run python script.py        # Handles venv automatically

# Global tools
uv tool install [tool]         # e.g., ruff, black, pytest

# Fix broken environment
mise uninstall python@X && mise install python@X
```

## Dotfiles Management (chezmoi)

### Workflow
- All dotfiles managed via chezmoi at `~/.local/share/chezmoi/`
- Add new configs: `chezmoi add <path>`
- Apply changes: `chezmoi apply` or `chezmoi apply <path>`
- Sync to remote: Standard git workflow in `~/.local/share/chezmoi/`
- Portable paths: Use `~/` not `/Users/nick/` for cross-platform configs

### Files to Exclude
- Runtime files: `fish_variables`, cache files, session data
- Platform-specific files handled via templates with `.tmpl` extension
- Use `.chezmoiignore` for files that shouldn't be applied

## System Information

### Local Machines
- **Mac** (primary): macOS, user: `nick`, Tailscale: available
- **Fedora PC**: Linux (Fedora), user: `nick`, Tailscale: `fedora` (100.93.39.25)

### Remote Access
- Sync dotfiles to Fedora: `ssh nick@fedora 'chezmoi update'`
- Both machines use same username: `nick`

### MCP Server API Keys
Environment variables needed on both machines:
- `EXA_API_KEY` - Exa search API
- `BRAVE_API_KEY` - Brave search API

**Fedora PC**: Keys need to be added to `~/.bashrc` or `~/.config/fish/config.fish`

## Quick Reference

### Common Error → Fix
| Error | Fix Command | Context |
|-------|-------------|---------|
| `mise: command not found` | `curl https://mise.jdx.dev/install.sh \| sh` | Python setup |
| `uv: not found` | `mise use python@latest && pip install uv` | Python env |
| `Permission denied` | `ls -la` to check permissions | File access |
| Fish syntax error | Wrap in `bash -c "command"` | Shell compatibility |

### ASK on Blockers
STOP and ask for clarification when hitting:
- Package name conflicts (PyPI, npm, etc.)
- Permission/access denied errors
- API rejections or unexpected failures
- Service unavailable or quota exceeded
- Ambiguous requirements or conflicting constraints

## Performance Testing
- Run benchmarks 3+ times, report median
- Include: hardware, data size, version info
- Use exact numbers: "156,937 req/s" not "~157K"
- Compare against baseline if available

---
*Streamlined for Sonnet 4.5 - Focus on personal preferences & workflows*