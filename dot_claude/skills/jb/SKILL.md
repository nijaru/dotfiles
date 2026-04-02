---
name: jb
description: Use when running commands expected to take several minutes or more (dev servers, large builds, full test suites).
allowed-tools: Bash, Read
---

# jb (Job Manager)

## Core Mandates

- **Don't Block:** Use `jb run` for tasks expected to take several minutes or more (dev servers, full builds, exhaustive test suites). When in doubt, run directly.
- **Monitor:** Use `jb logs --follow` or `jb wait` to track progress without losing context.
- **Cleanup:** Stale jobs should be cleaned with `jb clean` to keep the workspace responsive.

## Technical Standards

### 1. Job Invocation

| Task              | Command                   | Strategy                                  |
| :---------------- | :------------------------ | :---------------------------------------- |
| **Start Job**     | `jb run "command"`        | Run in background immediately.            |
| **Named Job**     | `jb run -n "build" "..."` | Use names for easier tracking.            |
| **Wait & Finish** | `jb wait <id>`            | Block only when necessary for next steps. |
| **Check Logs**    | `jb logs <id> --tail 50`  | Verify output without full context dump.  |

### 2. Operational Flow

- **Avoid parallel contention:** Do not run multiple jobs that mutate the same files (e.g., two `uv sync` calls).
- **Idempotency:** Use `-k <key>` for jobs that should not overlap (e.g., continuous build watchers).
- **Timeout management:** Use `-t <duration>` for exploratory tasks that might hang.

### 3. Management

- `jb ls`: Regularly check for orphaned or failed jobs.
- `jb status`: Detailed state of the job engine.
- `jb retry <id>`: Quick recovery for transient failures.

## Anti-Rationalization

| Excuse             | Reality                                                     |
| :----------------- | :---------------------------------------------------------- |
| "It'll be fast"    | It rarely is. Don't block your context on IO or compute.    |
| "I'll just wait"   | While waiting, you're costing tokens and time. Use `jb`.    |
| "I'll check later" | Without `jb`, checking later means guessing if it finished. |
