# [project-name]

This repo runs autonomous experiments against a fixed harness.

## Setup

Work with the user to:

1. Agree on a run tag and create a fresh branch for the run.
2. Read the in-scope files for full context.
3. Verify required data or cached artifacts exist.
4. Initialize the untracked results log if it does not exist.
5. Confirm setup before starting the loop.

## In-Scope Files

- Immutable files: [list them]
- Mutable files: [list them]
- Optional docs or references: [list them]

## Experimentation Rules

You may:

- edit only the mutable files
- run the approved experiment command
- record results in the untracked log

You may not:

- modify the evaluation harness
- modify data prep unless the user explicitly requests a redesign
- add dependencies unless the user explicitly approves it

## Goal

Optimize this metric: `[metric-name]`

Comparison rule:

- `[lower or higher] is better`

Time budget:

- `[budget and timeout rule]`

Complexity rule:

- prefer simpler wins
- revert tiny gains that add brittle complexity

## Output Extraction

Run experiments with output redirected to a log file:

```bash
[experiment-command] > run.log 2>&1
```

Extract only the comparison metrics:

```bash
[metric-extraction-command]
```

If extraction fails, inspect the tail of the log:

```bash
tail -n 50 run.log
```

## Results Log

Keep an untracked tab-separated log with a schema like:

```tsv
commit	metric	memory_gb	status	description
```

Statuses:

- `keep`
- `discard`
- `crash`

## Loop

1. Check current branch and commit.
2. Make one experimental change.
3. Commit the change.
4. Run the experiment.
5. Extract the metric.
6. Log the result.
7. Keep the commit only if it improves the metric enough to justify the complexity.
8. Revert failed or non-improving runs.
9. Continue until the user stops the run.
