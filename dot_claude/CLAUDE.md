# Personal Preferences & Workflows

## Git Preferences
- **NO AI attribution** - Never add "🤖 Generated with Claude" or similar to commits/PRs
- **STRIP attribution** - Remove any AI attribution found in existing commits/code
- **No auto PR** - Never open pull requests without explicit permission
- **No auto push** - Always ask before pushing to remote
- **Commit format**: `type: description` (feat, fix, docs, refactor, test, chore)
- **NO archiving** - Delete files directly, don't "archive" them. Git history preserves everything

## Code Comment Philosophy

**Default**: Most code needs NO comments. Well-structured code is self-documenting.

### ✅ GOOD Comments (Rare but Valuable)
- **WHY decisions**: `# Use 1000 threshold - benchmarks show 3x speedup`
- **Non-obvious requirements**: `# EU GDPR requires 7-year retention`
- **Complexity notes**: `# O(n log n) despite linear scan - sorting dominates`
- **External workarounds**: `# Workaround: Library X lacks feature Y`
- **Algorithm rationale**: `# Quickselect over sort - only need top K`

### ❌ BAD Comments (Never Add These)
- **WHAT code does**: `# Increment counter` (obvious from code)
- **Narrative/emotional**: `# CRITICAL FIX!` `# This works perfectly!`
- **Debugging breadcrumbs**: `# TODO: Fix this` (remove before commit)
- **Syntax explanation**: `# Convert to global ID` (use better variable names)
- **Stating the obvious**: `# Update size` for `size += count`

### 📏 Comment Litmus Test
Before adding ANY comment, ask:
1. Does this explain WHY, not WHAT?
2. Will this be valuable in 6 months?
3. Can better naming eliminate this comment?

**Example**: Instead of commenting, use clear names:
```python
# Bad: Comment needed
id = s * c + l  # Calculate global ID

# Good: Self-documenting
global_id = segment_id * segment_capacity + local_node_id
```

## Web Development

- **Use icons, not emojis** - Use icon libraries (lucide, heroicons, etc.) instead of emoji characters in UI

## Development Workflow

- **Commit frequently** - After each logical change
- **NO temp files** - Delete after use, don't leave around
- **Keep docs current** - Update documentation when changing related code

## Python Development (Personal Stack)

### Toolchain: uv + mise
```bash
# New project
mise install python@latest && mise use python@latest
uv init && uv sync

# Add dependencies
uv add [packages]              # Never use pip install
uv add --dev [dev-packages]    # Dev dependencies

# Run code
uv run python script.py        # Handles venv automatically

# Global tools
uv tool install [tool]         # e.g., ruff, black, pytest

# Fix broken environment
mise uninstall python@X && mise install python@X
```

## Dotfiles Management (chezmoi)

### Workflow
- All dotfiles managed via chezmoi at `~/.local/share/chezmoi/`
- Add new configs: `chezmoi add <path>`
- Apply changes: `chezmoi apply` or `chezmoi apply <path>`
- Sync to remote: Standard git workflow in `~/.local/share/chezmoi/`
- Portable paths: Use `~/` not `/Users/nick/` for cross-platform configs

### Files to Exclude
- Runtime files: `fish_variables`, cache files, session data
- Platform-specific files handled via templates with `.tmpl` extension
- Use `.chezmoiignore` for files that shouldn't be applied

## System Information

- **Mac** (primary): M3 Max, 128GB, Tailscale: `nick@apple`
- **Fedora PC**: i9-13900KF, 32GB DDR5, RTX 4090, Tailscale: `nick@fedora`

## Quick Reference

### Common Error → Fix
| Error | Fix Command | Context |
|-------|-------------|---------|
| `mise: command not found` | `curl https://mise.jdx.dev/install.sh \| sh` | Python setup |
| `uv: not found` | `mise use python@latest && pip install uv` | Python env |
| `Permission denied` | `ls -la` to check permissions | File access |
| Fish syntax error | Wrap in `bash -c "command"` | Shell compatibility |

### ASK on Blockers
STOP and ask for clarification when hitting:
- Package name conflicts (PyPI, npm, etc.)
- Permission/access denied errors
- API rejections or unexpected failures
- Service unavailable or quota exceeded
- Ambiguous requirements or conflicting constraints

## Performance Testing & Benchmarking

### Golden Rules
- Run benchmarks 3+ times, report median
- Include: hardware, data size, version info
- Use exact numbers: "156,937 req/s" not "~157K"
- Compare against baseline if available

### CRITICAL: Honest Comparisons Only

**⚠️ NEVER compare different levels of the stack**

❌ **INVALID Comparisons:**
- In-memory structure vs full database (different features)
- Algorithm vs complete system (missing I/O, durability, concurrency)
- Best-case data distribution vs real workload
- Bulk operations vs incremental operations
- System with feature X disabled vs system with feature X enabled

✅ **VALID Comparisons:**
- Full system vs full system (same features enabled)
- Same workload, same data distribution on both sides
- Document what's included/excluded explicitly

### Benchmark Checklist

Before claiming "Nx faster", verify:
- [ ] **Same features**: Both systems have persistence, ACID, durability, etc.
- [ ] **Same data**: Same distribution (sequential/random/zipfian/realistic)
- [ ] **Same workload**: Same operations (bulk vs incremental, read vs write ratio)
- [ ] **Same environment**: Same hardware, OS, file system
- [ ] **Multiple runs**: At least 3 runs, report median + variance
- [ ] **Documented caveats**: Explicitly state what IS and ISN'T tested

### Documentation Template

```markdown
## Benchmark: [Name]

**Systems Compared:**
- System A: [version, features enabled, configuration]
- System B: [version, features enabled, configuration]

**Data:**
- Distribution: [sequential/random/zipfian/mixed]
- Size: [rows, GB, unique keys]
- Schema: [structure]

**Workload:**
- Operations: [bulk insert/point queries/range scans/mixed]
- Pattern: [how data is accessed]
- Concurrency: [threads, connections]

**Results:**
| Metric | System A | System B | Speedup |
|--------|----------|----------|---------|
| Throughput | X ops/sec | Y ops/sec | Z.Zx |
| Latency (p50) | X ms | Y ms | Z.Zx |
| Latency (p99) | X ms | Y ms | Z.Zx |

**Caveats:**
- Tested on [specific data distribution] only
- [What features are/aren't included]
- [What this proves/doesn't prove]

**Honest Assessment:**
[What this means in practice, limitations, when speedup applies]
```

### Performance Claims

**When you want to say:**
> "System X is Nx faster than Y"

**Actually say:**
> "System X delivers Nx faster [specific operation] for [specific workload type] on [specific data distribution]. Tested with [features enabled]. [Other workloads/data types]: performance TBD."

**Example - Bad:**
> "OmenDB is 500x faster than SQLite"

**Example - Good:**
> "OmenDB delivers 20-50x faster bulk inserts for time-series workloads (sequential timestamps) compared to SQLite, with durability enabled on both systems. Tested at 10M rows. Random UUID performance: 2-5x faster."

### Red Flags to Avoid

🚩 **Suspiciously high speedups** (100x+):
- Usually means you're comparing different things
- Check if both systems have same features enabled
- Verify data distribution is realistic

🚩 **Only testing best-case data:**
- Sequential/sorted data is optimal for many algorithms
- Always test random/zipfian/realistic distributions too

🚩 **Vague claims:**
- "Faster" without context
- No mention of workload type
- No documentation of what's tested

### ASK Before Publishing

When benchmarks show exceptional results (>50x), STOP and verify:
1. Are we comparing the same level of abstraction?
2. Are all features accounted for on both sides?
3. Have we tested on realistic data distributions?
4. Can we explain WHY the speedup is this large?
5. What happens when we add missing features?

If uncertain, document honestly and flag caveats.

---
*Updated Oct 2025 - Added benchmarking guidelines after misleading comparison incident*