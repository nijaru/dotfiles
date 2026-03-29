---
name: nu-data
description: Use when about to reach for jq, awk, or a Python one-liner to query, filter, or transform structured data (JSON, CSV, TOML, NDJSON, Parquet).
allowed-tools: Bash, Read, Write, Edit
---

# Nushell as a Data Tool

## Core Principle

Nu treats structured data as native tables. Reach for it over `jq` when exploring unknown shapes, doing multi-step transforms, or working with multiple formats.

## When to Use vs. jq

| Situation                        | Tool        |
| -------------------------------- | ----------- |
| Exploring unknown JSON structure | `nu`        |
| Multi-step filter + reshape      | `nu`        |
| Multi-format (JSON + CSV + TOML) | `nu`        |
| One-liner in a bash/fish script  | `jq`        |
| CI/CD pipeline (portability)     | `jq`        |
| Pure regex text matching         | `grep`/`rg` |

## Common Patterns

### Open and explore

```nu
open data.json                          # auto-parsed table
open data.json | explore               # interactive TUI browser
open data.json | describe             # show schema
```

### Filter and select

```nu
open users.json | where age > 30
open users.json | get users | select name email
open users.json | get users.0.name    # dot-path indexing
```

### Multiple files / formats

```nu
open data.csv | where status == "active" | to json
open config.toml | get database.host
ls *.json | each { |f| open $f.name | get id } | flatten
```

### NDJSON (newline-delimited)

```nu
open logs.ndjson | lines | each { |line| $line | from json } | where level == "error"
```

### Large data with Polars (requires plugin)

```nu
# Install once: plugin add ~/.cargo/bin/nu_plugin_polars
polars open large.parquet | polars filter col("age") > lit(30) | polars collect
```

### Reshape and output

```nu
open data.json | get items | select name value | to csv
open data.json | update price { $in * 1.1 } | to json --indent 2
```

## Quick Reference

| Task              | Command                              |
| ----------------- | ------------------------------------ |
| Pretty print JSON | `open f.json`                        |
| Count records     | `open f.json \| length`              |
| Unique values     | `open f.json \| get field \| uniq`   |
| Sort              | `open f.json \| sort-by field`       |
| Group by          | `open f.json \| group-by field`      |
| Flatten nested    | `open f.json \| flatten`             |
| Convert format    | `open f.csv \| to json`              |
| Filter nulls      | `open f.json \| where field != null` |

## Running from Fish

```fish
nu -c "open data.json | where active == true | to json"
```

Or pipe into nu:

```fish
cat data.json | nu -c "from json | where active == true"
```

## Common Mistakes

- `open` auto-detects format by extension — for ambiguous files use `open f.txt | from json`
- Nu paths use `.` not `[]` for array index: `get users.0` not `get users[0]`
- String interpolation uses `$"..."`: `$"Hello ($name)"`
- Pipelines in `each` blocks need explicit params: `{ |row| ... }` not `{ ... }`
