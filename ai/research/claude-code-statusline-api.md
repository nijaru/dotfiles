# Claude Code Statusline API Research

**Date:** 2026-02-13
**Source:** Official docs (code.claude.com/docs/en/statusline), GitHub issues, community projects
**Versions tested:** v2.1.37-2.1.38 (latest as of research date)

## Complete JSON Schema

The statusline script receives this JSON via stdin after each assistant message:

```json
{
  "cwd": "/current/working/directory",
  "session_id": "abc123...",
  "transcript_path": "/path/to/transcript.jsonl",
  "model": {
    "id": "claude-opus-4-6",
    "display_name": "Opus"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.0.80",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  },
  "context_window": {
    "total_input_tokens": 15234,
    "total_output_tokens": 4521,
    "context_window_size": 200000,
    "used_percentage": 8,
    "remaining_percentage": 92,
    "current_usage": {
      "input_tokens": 8500,
      "output_tokens": 1200,
      "cache_creation_input_tokens": 5000,
      "cache_read_input_tokens": 2000
    }
  },
  "exceeds_200k_tokens": false,
  "vim": {
    "mode": "NORMAL"
  },
  "agent": {
    "name": "security-reviewer"
  }
}
```

## Field Reference

| Field                                                      | Type        | Description                                                    |
| ---------------------------------------------------------- | ----------- | -------------------------------------------------------------- |
| `cwd`                                                      | string      | Current working directory (raw path, no ~ substitution)        |
| `session_id`                                               | string      | Unique session identifier                                      |
| `transcript_path`                                          | string      | Path to conversation transcript file                           |
| `model.id`                                                 | string      | Full model ID (e.g., `claude-opus-4-6`)                        |
| `model.display_name`                                       | string      | Short name (e.g., `Opus`)                                      |
| `workspace.current_dir`                                    | string      | Same as `cwd` (preferred over `cwd`)                           |
| `workspace.project_dir`                                    | string      | Directory where Claude Code was launched (may differ from cwd) |
| `version`                                                  | string      | Claude Code version                                            |
| `output_style.name`                                        | string      | Current output style name                                      |
| `cost.total_cost_usd`                                      | number      | Cumulative session cost in USD                                 |
| `cost.total_duration_ms`                                   | number      | Wall-clock time since session started                          |
| `cost.total_api_duration_ms`                               | number      | Time spent waiting for API responses                           |
| `cost.total_lines_added`                                   | number      | Lines of code added in session                                 |
| `cost.total_lines_removed`                                 | number      | Lines of code removed in session                               |
| `context_window.total_input_tokens`                        | number      | Cumulative input tokens across session                         |
| `context_window.total_output_tokens`                       | number      | Cumulative output tokens across session                        |
| `context_window.context_window_size`                       | number      | Max tokens (200000 default, 1000000 extended)                  |
| `context_window.used_percentage`                           | number/null | Pre-calculated % of context used                               |
| `context_window.remaining_percentage`                      | number/null | Pre-calculated % remaining                                     |
| `context_window.current_usage.input_tokens`                | number      | Input tokens in current context                                |
| `context_window.current_usage.output_tokens`               | number      | Output tokens generated                                        |
| `context_window.current_usage.cache_creation_input_tokens` | number      | Tokens written to cache                                        |
| `context_window.current_usage.cache_read_input_tokens`     | number      | Tokens read from cache                                         |
| `exceeds_200k_tokens`                                      | boolean     | Whether last API response exceeded 200k total tokens           |
| `vim.mode`                                                 | string      | `NORMAL` or `INSERT` (only present when vim mode enabled)      |
| `agent.name`                                               | string      | Agent name (only present with --agent flag)                    |

## Key Answers

### Is there a built-in context percentage?

YES. `context_window.used_percentage` and `context_window.remaining_percentage` are pre-calculated.
The formula: `input_tokens + cache_creation_input_tokens + cache_read_input_tokens` (output_tokens excluded).

### Is there a git branch field?

NO. Git info must be fetched by the script itself via `git branch --show-current`. The docs recommend caching git operations to avoid lag (5-second cache pattern shown in examples).

### Is there a formatted cwd with ~?

NO. `cwd` and `workspace.current_dir` provide raw absolute paths. You must format yourself:

```bash
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|^$HOME|~|")
```

### What fields are in context_window?

See schema above. Two categories:

1. **Cumulative totals** (`total_input_tokens`, `total_output_tokens`): sum across entire session
2. **Current usage** (`current_usage`): tokens from the most recent API call (actual context state)
   Plus: `context_window_size`, `used_percentage`, `remaining_percentage`

### Newer fields added since mid-2025?

Added in v2.0.65 (Dec 2025): `context_window` object with token data
Added in v2.0.72: `current_usage` sub-object
Added ~v2.1.x: `used_percentage`, `remaining_percentage` (pre-calculated)
Added: `workspace.project_dir` (distinguishes launch dir from cwd)
Added: `cost.total_api_duration_ms`, `cost.total_lines_added`, `cost.total_lines_removed`
Added: `exceeds_200k_tokens`
Added: `vim.mode`, `agent.name`

## NOT yet available (open feature requests)

- `fast_mode` state (#24279) - no way to detect /fast toggle
- `effort` level (#24758) - max/high/medium/low not exposed
- Rate limit / plan usage data (#25041, #25420) - 5-hour window usage not exposed
- Session name (#18022, #25501) - no session naming in JSON
- Account email (#24679)
- Active skills (#24314, #16078)

## Context Window Accuracy Issues

### Historical Bug: Cumulative Tokens (#13783)

- Original `context_window` fields (v2.0.65) provided cumulative session tokens, not current context usage
- Fix: `used_percentage` was added and uses `current_usage` data from the last API response
- Confirmed fixed as of v2.1.38 (per user reports in #13783)

### Remaining Discrepancy (~10-20%)

- `used_percentage` may still differ from `/context` command output (#20638)
- Root cause: system prompt overhead (tool definitions, MCP servers, CLAUDE.md, memory files) may not be fully accounted for in `current_usage`
- The `/context` command shows a breakdown: system_prompt, system_tools, mcp_tools, custom_agents, memory_files, messages
- `current_usage` only reports what the API returns; it doesn't include the fixed overhead

### Compaction Behavior

- After `/compact`, `used_percentage` DOES reset appropriately (reflects new smaller context)
- `total_input_tokens` and `total_output_tokens` remain cumulative (they grow across the whole session, even past compactions)
- The statusline does NOT auto-refresh after `/compact` (#25248 - open bug). It updates on the next assistant message.
- Auto-compaction works the same way: percentage drops after compaction, but cumulative totals keep growing.

### Recommendation for Accurate Context Tracking

Use `context_window.used_percentage` directly. Do NOT calculate from cumulative totals.
If you need to account for system overhead, add ~15-20% empirically (not reliable).
The pre-calculated percentage is the best available signal, even if imperfect.

## Configuration

Settings location: `~/.claude/settings.json`

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 2
  }
}
```

- `padding`: extra horizontal spacing (characters), defaults to 0
- `command`: can be a script path or inline shell command
- Script runs after each assistant message, on permission mode change, or vim toggle
- Updates debounced at 300ms; in-flight execution cancelled if new update triggers
- Multiple `echo`/`print` statements = multiple lines in status area

## Update Triggers

- After each assistant message
- Permission mode change
- Vim mode toggle
- NOT after `/compact` (bug #25248)
- NOT when output style changes mid-session (bug #22643)
