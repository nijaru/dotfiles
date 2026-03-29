---
name: hyperfine
description: Use when benchmarking CLI tools or scripts instead of time — measuring performance, comparing implementations, or tracking regressions with statistical validity.
allowed-tools: Bash, Read, Write, Edit
---

# Hyperfine Benchmarking

## Core Principle

Benchmarks are only valid if they measure equivalent configurations under controlled conditions. Report methodology — not just numbers.

## Iron Rules

- Always warm up (`--warmup`). Cold caches lie.
- Always compare equivalent configs. Different flags = different programs.
- Always report: command, warmup count, run count, environment.
- Never benchmark debug builds against release builds.
- Profile before benchmarking — know what you're measuring.

## Basic Usage

```bash
# Single command
hyperfine --warmup 3 'my-command input.txt'

# Compare two commands (equivalent configs)
hyperfine --warmup 3 \
  'tool-a --flag input.txt' \
  'tool-b --flag input.txt'

# Parametric sweep
hyperfine --warmup 3 \
  --parameter-scan size 100 1000 100 \
  'my-command --size {size}'
```

## Key Flags

| Flag                        | Use                                                      |
| --------------------------- | -------------------------------------------------------- |
| `--warmup N`                | Discard first N runs (always use, min 3)                 |
| `--runs N`                  | Fixed run count (default: auto, min 10)                  |
| `--min-runs N`              | Minimum when using auto                                  |
| `--prepare CMD`             | Run before each timing (clear caches, reset state)       |
| `--setup CMD`               | Run once before all runs                                 |
| `--cleanup CMD`             | Run after all runs                                       |
| `--export-json out.json`    | Machine-readable results                                 |
| `--export-markdown out.md`  | Table for docs/PRs                                       |
| `--shell none`              | Remove shell overhead for simple commands                |
| `--ignore-failure`          | Benchmark even if exit code nonzero                      |
| `--parameter-list VAR LIST` | Discrete values sweep (vs `--parameter-scan` for ranges) |

## Cache Control

```bash
# macOS — drop file system cache
sudo purge

# Linux — drop page cache
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches

# Use --prepare to reset between runs
hyperfine --warmup 3 \
  --prepare 'sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null' \
  'find /large/dir -name "*.log"'
```

## Reporting Template

When presenting results, always include:

```
Tool:        hyperfine 1.x
Warmup:      3 runs
Measured:    10+ runs (auto)
Machine:     [CPU, RAM, OS]
Dataset:     [size, format, source]
Commands:    [exact commands with flags]
```

## Common Mistakes

| Mistake                         | Fix                                              |
| ------------------------------- | ------------------------------------------------ |
| Benchmarking without warmup     | Always `--warmup 3` minimum                      |
| Comparing debug vs release      | Match build flags exactly                        |
| No cache preparation            | Use `--prepare` to reset state                   |
| Reporting mean only             | Include stddev — high variance = noisy benchmark |
| Different input sizes           | Use `--parameter-list` to sweep fairly           |
| Shell overhead in fast commands | Use `--shell none` for sub-millisecond ops       |

## Interpreting Results

- **Mean ± stddev** — primary metric. High stddev means noisy; run on idle machine.
- **Min** — useful for CPU-bound tasks (best-case without interference).
- **Relative speed** shown automatically when comparing — trust the ratio, not just the absolute.
- Statistical significance: hyperfine runs until confident. Don't override `--runs` downward without reason.

## Export and Diff

```bash
# Save baseline and new results separately
hyperfine --warmup 3 --export-json before.json 'old-tool input'
hyperfine --warmup 3 --export-json after.json 'new-tool input'

# Compare with hyperfine's bundled script
# (find it at: $(dirname $(which hyperfine))/../share/hyperfine/scripts/)
python3 scripts/compare.py before.json after.json

# Or extract means manually
jq '.results[0] | {command, mean, stddev}' before.json after.json
```
