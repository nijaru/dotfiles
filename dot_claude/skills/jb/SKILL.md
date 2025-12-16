---
name: jb
description: >
  Background job manager for long-running commands.
  Triggers on: "run in background", "takes a while", "long running",
  builds >30s, test suites, deployments, dev servers, anything that
  should survive session disconnect.
allowed-tools: Bash(command:jb*)
---

# jb

Background job manager. Use instead of raw bash for commands >30s.

## Triggers

- "run this in background", "this takes a while"
- "start the build", "run the tests" (when known to be slow)
- "start dev server", "run watch mode"
- Long-running deployments, migrations
- Any command that should survive disconnect

## Decision

Use `jb run` when:
- Command takes >30 seconds
- Process should survive session disconnect
- Running multiple tasks in parallel
- Need to check output later

Do NOT use for: quick commands (<10s), interactive/TTY, stdin-dependent.

## Commands

```bash
jb run "cmd"                    # Start, returns ID immediately
jb run "cmd" --wait             # Start and block
jb run "cmd" --name build       # Named reference
jb run "cmd" --timeout 30m      # With timeout
jb run "cmd" --key "unique"     # Idempotent (won't duplicate)

jb list                         # Current project jobs
jb list --all                   # All projects
jb list --status running        # Filter: pending|running|completed|failed|stopped

jb status <id>                  # Job details
jb status                       # Daemon status

jb logs <id>                    # Full output
jb logs <id> --tail             # Last 50 lines
jb logs <id> --follow           # Stream live

jb stop <id>                    # Graceful (SIGTERM)
jb stop <id> --force            # Kill (SIGKILL)

jb wait <id>                    # Block until done
jb wait <id> --timeout 5m       # Exit: 0=success, 1=failed, 124=timeout

jb retry <id>                   # Re-run failed job

jb clean                        # Remove >7 days old
jb clean --older-than 1d
```

## Patterns

```bash
# Parallel execution
jb run "npm test" --name tests
jb run "npm run lint" --name lint
jb run "cargo build" --name build
jb list  # check progress

# Wait for all
jb wait tests && jb wait lint && jb wait build

# Resume after break
jb list
jb logs <id> --tail
```

## Storage

`~/.jb/` contains database and logs. Run `jb clean` periodically.
