# Claude Code MCP Server Configuration

MCP servers are configured via **external config file** managed by chezmoi.

## How It Works

1. **`~/.config/claude/mcp-servers.json`** - MCP server definitions (managed by chezmoi)
2. **`claude` fish function** - Automatically loads the external config with `--strict-mcp-config`
3. **Environment variables** - API keys from `secrets.fish` are expanded via `${VAR}` syntax

## Current Servers

- **context7**: No authentication
- **brave-search**: Uses `${BRAVE_API_KEY}`
- **exa**: Uses `${EXA_API_KEY}`
- **parallel-search-mcp**: Uses `${PARALLEL_API_KEY}`

## Important Notes

- The `claude` function uses `--strict-mcp-config` to **ignore** servers in `~/.claude.json`
- `claude mcp list` shows servers from `~/.claude.json` (not the external config)
- To see which servers are actually loaded, run `claude` in interactive mode and check `/mcp`

## When API Keys Change

1. Update keys in `~/.config/chezmoi/chezmoi.toml`
2. Run `chezmoi apply`
3. Start new shell (loads new env vars from `secrets.fish`)
4. Claude Code automatically uses new values via `${VAR}` expansion

## Cross-Machine Setup

```bash
chezmoi init --apply https://github.com/nijaru/dotfiles
# MCP servers automatically configured!
```

## Manual Management (Not Recommended)

If you want to manage servers via `claude mcp add/remove` instead:
1. Remove the `--strict-mcp-config` flag from `~/.config/fish/functions/claude.fish`
2. Configure servers with: `claude mcp add --transport stdio brave-search -s user --env 'BRAVE_API_KEY=${BRAVE_API_KEY}' -- npx -y @brave/brave-search-mcp-server`

But the external config file approach is recommended for chezmoi management.
