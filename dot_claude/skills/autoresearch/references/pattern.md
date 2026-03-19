# Autoresearch Pattern

The right default is both, with a clear split:

- Put the reusable pattern in `SKILL.md`.
- Put Karpathy's repo-specific details in a reference file.
- Keep a concrete `program.md` template in `assets/`.

If the skill only documents `karpathy/autoresearch`, it becomes brittle and less reusable. If it only documents the abstract pattern, it loses the operational details that make the workflow actually work. The best version keeps the skill centered on the pattern and uses `autoresearch` as the reference implementation.

## The Pattern

An autoresearch loop needs five stable pieces:

1. A fixed harness
2. A small mutable surface
3. A single comparison metric
4. A result log outside git history
5. A keep-or-revert rule

Without all five, unattended iteration tends to drift, overfit to noisy signals, or corrupt the baseline.

## Design Rules

### 1. Freeze the harness

Keep evaluation, data prep, and environment rules outside the agent's edit surface. Otherwise the agent can improve the score by changing the test instead of improving the system.

### 2. Make the mutable surface obvious

The best autoresearch repos have one file or one narrow module that the agent can change. Narrow surfaces keep diffs reviewable and rollback simple.

### 3. Time-box experiments

Use a fixed budget per run so comparisons stay meaningful. This is the key trick in the upstream repo: the model can change, but each experiment gets the same wall-clock budget.

### 4. Keep only improvements

The branch should advance only on improvement. This turns the repo into a hill-climbing loop instead of an ever-growing pile of failed ideas.

### 5. Log every attempt

Even crashes and regressions are useful if they are captured with a short description. The log is the memory of the overnight run.

## Adaptation Checklist

When applying the pattern to a different repo, define:

- the immutable files
- the mutable files
- the exact success metric
- the baseline command
- the experiment command
- the timeout rule
- the log format
- the rollback command

If any of those are vague, fix the repo design first and only then let the agent run unattended.
