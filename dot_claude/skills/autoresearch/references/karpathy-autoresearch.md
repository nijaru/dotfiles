# Karpathy Autoresearch Reference

Source repo: [karpathy/autoresearch](https://github.com/karpathy/autoresearch)

This repo is the cleanest current reference implementation of the pattern:

- `prepare.py` is the fixed harness. It owns the time budget, tokenizer, data loading, and evaluation utilities.
- `train.py` is the mutable surface. The agent experiments there.
- `program.md` is the operating prompt for the autonomous loop.

## Key Constraints

- Metric: `val_bpb`
- Comparator: lower is better
- Experiment budget: 5 minutes of training time per run
- Timeout rule: kill runs that exceed the expected wall-clock window
- Dependency rule: do not add packages
- Logging rule: append results to an untracked `results.tsv`

## Core Commands

Environment setup:

```bash
uv sync
uv run prepare.py
```

Single run:

```bash
uv run train.py > run.log 2>&1
```

Metric extraction:

```bash
grep "^val_bpb:\|^peak_vram_mb:" run.log
```

Crash inspection:

```bash
tail -n 50 run.log
```

## What Makes It Work

The upstream project works well because the agent cannot quietly move the goalposts:

- data prep is fixed
- evaluation is fixed
- the experiment budget is fixed
- only the model and training logic move

That makes overnight iteration plausible instead of chaotic.

## What To Keep When Forking

Preserve these invariants even if you change the domain:

- one obvious mutable surface
- one trusted evaluator
- one durable results log
- one keep-or-revert loop
