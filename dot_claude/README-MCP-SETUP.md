# Claude Code & Claude Desktop MCP Configuration

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
2. Run `chezmoi apply`
3. Open new shell (loads new env vars from `secrets.fish`)
4. **Claude Code**: Automatically uses new values via `${VAR}` expansion
5. **Claude Desktop**: Restart app to reload config file

## Cross-Machine Setup

```bash
chezmoi init --apply https://github.com/nijaru/dotfiles
# Claude Code MCP servers automatically configured!
# Claude Desktop stdio servers automatically configured!
# Reminder: Add remote servers via Desktop UI Settings > Connectors
```
