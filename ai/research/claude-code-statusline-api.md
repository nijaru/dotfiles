# Claude Code Statusline API

**Last verified:** v2.1.37-2.1.38 (Feb 2026)

## Configuration

```json
// ~/.claude/settings.json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 2
  }
}
```

Script receives JSON via stdin after each assistant message. Multiple `echo` lines = multiple status lines.

**Triggers:** assistant message, permission mode change, vim toggle.
**Not triggered:** after `/compact` (bug #25248), output style change (bug #22643).
Debounced at 300ms; in-flight execution cancelled on new trigger.

## JSON Schema

```json
{
  "cwd": "/absolute/path",
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "model": { "id": "claude-opus-4-6", "display_name": "Opus" },
  "workspace": {
    "current_dir": "/absolute/path",
    "project_dir": "/launch/directory"
  },
  "version": "1.0.80",
  "output_style": { "name": "default" },
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
  "vim": { "mode": "NORMAL" },
  "agent": { "name": "security-reviewer" }
}
```

**Non-obvious fields:**

- `workspace.project_dir` — launch dir, may differ from `cwd` after `cd`
- `context_window.total_*` — cumulative for entire session (grows past compactions)
- `context_window.current_usage` — reflects the last API call's actual context
- `used_percentage` — pre-calculated, use this; don't calculate from totals
- `vim` — only present when vim mode enabled
- `agent` — only present with `--agent` flag

## Key Gotchas

**No git branch** — fetch it yourself: `git branch --show-current` (cache for 5s to avoid lag).

**No `~` in paths** — format manually:

```bash
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|^$HOME|~|")
```

**Context % accuracy** — `used_percentage` may be 10-20% lower than `/context` output. Root cause: system prompt overhead (tool definitions, MCP servers, CLAUDE.md) isn't included in `current_usage`. Use `used_percentage` anyway — it's the best available signal. Resets correctly after `/compact`.

## Not Exposed (open feature requests)

| Field                   | Issue          |
| ----------------------- | -------------- |
| fast mode state         | #24279         |
| effort level            | #24758         |
| rate limit / 5-hr usage | #25041, #25420 |
| session name            | #18022, #25501 |
| account email           | #24679         |
| active skills           | #24314, #16078 |
