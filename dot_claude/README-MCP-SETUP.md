# Claude Code MCP Server Configuration

MCP servers are configured via **external config file** managed by chezmoi.

## Setup

MCP servers are defined in `~/.config/claude/mcp-servers.json` (managed by chezmoi).

The `claude` fish function automatically loads this config:
```fish
function claude
    command claude --mcp-config ~/.config/claude/mcp-servers.json $argv
end
```

## Current Servers

All MCP servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`
- **parallel-search-mcp**: Uses `${PARALLEL_API_KEY}`

## When API Keys Change

1. Update keys in `~/.config/chezmoi/chezmoi.toml`
2. Run `chezmoi apply`
3. Open new shell to load new env vars
4. Claude Code automatically uses new values via `${VAR}` expansion

## Manual Config (Not Recommended)

If you prefer to configure MCP servers in `~/.claude.json` directly:

```bash
claude mcp add --transport stdio brave-search -s user \
  --env 'BRAVE_API_KEY=${BRAVE_API_KEY}' \
  -- npx -y @brave/brave-search-mcp-server
```

But the external config file approach is cleaner and fully managed by chezmoi.
