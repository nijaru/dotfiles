---
description: Run long-running commands in background with jb. Use for builds, test suites, dev servers, benchmarks.
allowed-tools: Bash
---

# jb - Background Job Runner

Run commands expected to take >30s in background. Persists across shell sessions.

## Commands

```bash
jb run "cmd"           # Run in background
jb run "cmd" --follow  # Run and stream output
jb list                # List jobs
jb logs <id>           # Full output
jb logs <id> --tail    # Last 50 lines
jb logs <id> --follow  # Stream live
jb stop <id>           # Stop job
jb clean               # Remove finished jobs
```

## When to Use

- Builds (`cargo build`, `go build`, `bun build`)
- Test suites (`pytest`, `cargo test`, `bun test`)
- Dev servers (`bun run dev`, `cargo watch`)
- Benchmarks
- Any command >30s

## Workflow

1. `jb run "cargo build --release" --follow` - start and watch
2. Continue other work while it runs
3. `jb list` - check status
4. `jb logs <id> --tail` - check output
5. `jb stop <id>` - cancel if needed
