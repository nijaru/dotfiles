---
name: autoresearch
description: Use when setting up, documenting, or running an autonomous experiment loop with a fixed evaluation harness, a narrow edit surface, and keep-or-revert iteration; especially for karpathy/autoresearch-style overnight model tuning.
allowed-tools: Bash
---

# Autoresearch

Turn a small repo into a safe autonomous experiment loop. The core idea is not "let the agent change everything." The core idea is "lock the harness, narrow the edit surface, compare on one metric, and keep only improvements."

## When To Use

Use this skill when the user wants to:

- adapt or run `karpathy/autoresearch`
- write or improve a `program.md` or similar agent prompt for autonomous experiments
- document the rules for unattended experiment loops
- create a keep-or-revert workflow around a benchmark, training job, or other time-boxed evaluation

## First Pass

Before editing anything, identify:

1. Immutable files and rules
2. Mutable files
3. Primary success metric and whether higher or lower is better
4. Experiment time budget and timeout rule
5. Result log format and rollback policy

If the repo already follows Karpathy's layout, read `README.md`, `program.md`, the immutable harness file, and the mutable experiment file first.

## Core Loop

1. Verify the environment and baseline command work.
2. Freeze the evaluation harness.
3. Restrict edits to one small surface area when possible.
4. Run a baseline first and record it.
5. Make one experimental change at a time unless you are intentionally testing a bundle.
6. Redirect long output to a log file and extract only the comparison metrics.
7. Append each result to an untracked table or log.
8. Keep commits that improve the metric enough to justify the added complexity.
9. Revert non-improving or broken experiments immediately.
10. Continue autonomously once the loop begins unless the user explicitly asks for checkpoints.

## Guardrails

- Do not change data prep, evaluation, or dependencies unless the user explicitly wants to redesign the harness.
- Prefer simpler wins over tiny gains with fragile complexity.
- Treat crashes as data. Log them, revert, and move on.
- If the repo lacks a clean keep-or-revert mechanic, add one before attempting unattended runs.
- Keep logs out of the main context window.

## What To Produce

When the user asks for a skill or `program.md`, usually produce:

- a concise operating prompt for the agent
- explicit immutable vs mutable file boundaries
- commands for baseline run, experiment run, metric extraction, and rollback
- a result log format that survives long unattended runs

## Load These Only When Needed

- Read [references/pattern.md](references/pattern.md) when deciding how much of the broad method versus repo-specific details to encode.
- Read [references/karpathy-autoresearch.md](references/karpathy-autoresearch.md) for the concrete mapping from the upstream repo.
- Reuse [assets/program-template.md](assets/program-template.md) when drafting a new `program.md`.
