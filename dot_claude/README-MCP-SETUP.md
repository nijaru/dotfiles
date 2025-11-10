# Claude Code MCP Server Configuration

MCP servers are configured in `~/.claude.json` with environment variable references.

## Current Setup

All MCP servers use `${VAR}` syntax to reference environment variables from `~/.config/fish/secrets.fish`:

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`
- **parallel-search-mcp**: Uses `${PARALLEL_API_KEY}`

## To Reconfigure (if needed)

```bash
# Remove existing servers
claude mcp remove context7 -s user
claude mcp remove brave-search -s user
claude mcp remove exa -s user
claude mcp remove parallel-search-mcp -s user

# Add with env var references
claude mcp add --transport stdio context7 -s user -- npx -y context7-mcp-server

claude mcp add --transport stdio brave-search -s user \
  --env 'BRAVE_API_KEY=${BRAVE_API_KEY}' \
  -- npx -y @brave/brave-search-mcp-server

claude mcp add --transport stdio exa -s user \
  --env 'EXA_API_KEY=${EXA_API_KEY}' \
  -- npx -y exa-mcp-server

# HTTP server (parallel-search-mcp) - update manually in .claude.json
jq '.mcpServers["parallel-search-mcp"] = {
  "type": "http",
  "url": "https://search-mcp.parallel.ai/mcp",
  "headers": {"Authorization": "Bearer ${PARALLEL_API_KEY}"}
}' ~/.claude.json > /tmp/claude.json.tmp && mv /tmp/claude.json.tmp ~/.claude.json
```

## When API Keys Change

1. Update keys in `~/.config/chezmoi/chezmoi.toml`
2. Run `chezmoi apply`
3. Open new shell to load new env vars
4. Claude Code automatically uses new values via `${VAR}` expansion
