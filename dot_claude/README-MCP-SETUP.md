# MCP Configuration Across CLI Tools

This document covers MCP server setup for Claude Code, Claude Desktop, Gemini CLI, Amp CLI, Droid, and Opencode.

## Claude Code CLI

### MCP Server Configuration

Servers are defined in `~/.config/claude/mcp-servers.json` (managed by chezmoi).

The `claude` fish function automatically loads this config:
```fish
function claude
    command claude --mcp-config ~/.config/claude/mcp-servers.json --strict-mcp-config $argv
end
```

### Current Servers (Claude Code)

All servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`
- **parallel-search-mcp**: Uses `${PARALLEL_API_KEY}` (HTTP server)

### Permission Mode

`~/.claude/settings.json` sets `permissions.defaultMode: "bypassPermissions"` so all tools are auto-approved.

## Claude Desktop App

### Stdio Servers (via Config File)

Configured in `~/Library/Application Support/Claude/claude_desktop_config.json` (managed by chezmoi):

- **context7**: No authentication
- **brave-search**: Uses `{{ .brave_api_key }}` template
- **exa**: Uses `{{ .exa_api_key }}` template

### Remote Servers (HTTP/SSE) - UI Only

**parallel-search-mcp cannot be configured via config file.** 

To add it:
1. Open Claude Desktop
2. Go to **Settings > Connectors**
3. Add remote MCP server:
   - URL: `https://search-mcp.parallel.ai/mcp`
   - Configure authentication (Bearer token or OAuth)

**Important**: Claude Desktop will NOT connect to remote servers configured in `claude_desktop_config.json`. They must be added through the UI.

### Permissions

Claude Desktop uses **UI-based permissions** (not settings.json):
- **Approve Once** - Single use
- **Allow for This Chat** - Session-level
- **Deny** - Block the tool

Each tool prompts for approval when first called.

## Updating API Keys

1. Update keys in `~/.config/chezmoi/chezmoi.toml`
2. Run `chezmoi apply --force`
3. Open new shell (loads new env vars from `secrets.fish`)
4. **CLI tools** (Claude Code, Gemini, Amp, Droid, Opencode): Automatically use new values via `${VAR}` expansion
5. **Claude Desktop**: Restart app to reload config file

## Gemini CLI

### MCP Server Configuration

Servers are defined in `~/.gemini/settings.json` (managed by chezmoi).

### Current Servers (Gemini CLI)

All servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`

### Verification

```bash
gemini mcp list  # Show configured servers and connection status
```

## Amp CLI

### MCP Server Configuration

Servers are defined in `~/.config/amp/settings.json` (managed by chezmoi).

### Current Servers (Amp CLI)

All servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`

## Droid (Factory.ai CLI)

### MCP Server Configuration

Servers are defined in `~/.factory/mcp.json` (managed by chezmoi).

CLI management:
```bash
droid mcp add <name> "<command>" --env KEY=value
droid mcp remove <name>
```

Interactive: Use `/mcp` command within Droid.

### Current Servers (Droid)

All servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`

### AGENTS.md Integration

Droid automatically loads `~/.factory/AGENTS.md` (symlinked to `~/.claude/CLAUDE.md`) for AI agent instructions.

## Opencode CLI

### MCP Server Configuration

Servers are defined in `~/.config/opencode/opencode.json` (managed by chezmoi).

### Current Servers (Opencode)

All servers use `${VAR}` syntax in the `environment` field to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication (enabled)
- **brave-search**: Uses `${BRAVE_API_KEY}` (enabled)
- **exa**: Uses `${EXA_API_KEY}` (enabled)

### AGENTS.md Integration

Opencode automatically loads `~/.config/opencode/AGENTS.md` (symlinked to `~/.claude/CLAUDE.md`) for AI agent instructions.

## Cross-Machine Setup

```bash
chezmoi init --apply https://github.com/nijaru/dotfiles
# All MCP servers automatically configured:
# - Claude Code CLI
# - Claude Desktop (stdio servers)
# - Gemini CLI
# - Amp CLI
# - Droid (Factory.ai CLI)
# - Opencode CLI
# Reminder: Add remote servers to Claude Desktop via UI Settings > Connectors
```
