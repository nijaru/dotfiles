# MCP Server Setup

## Claude Code

MCP servers are managed via CLI:

```bash
# Add server (user scope = all projects)
claude mcp add -s user <name> -- <command> [args...]

# List servers
claude mcp list

# Remove server
claude mcp remove <name>
```

### Current Setup

| Server   | Command                        | Auth | Purpose                    |
| -------- | ------------------------------ | ---- | -------------------------- |
| context7 | `npx -y @upstash/context7-mcp` | None | LLM-optimized library docs |

### Setup on New Machine

```bash
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
```

### Tools Available

- `mcp__context7__resolve-library-id` - Resolve library name to Context7 ID
- `mcp__context7__get-library-docs` - Fetch LLM-optimized documentation

## Other CLI Tools

For Gemini CLI, Amp CLI, Droid, Opencode - add Context7 to their respective configs if needed. No API keys required.

## Notes

- Claude Code's built-in `WebSearch` and `WebFetch` handle general web research
- Context7 is specifically optimized for library/SDK documentation
- No paid MCP servers (Exa, Parallel) - built-in tools are sufficient for most tasks
