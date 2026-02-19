---
name: codex
description: Use when needing agentic codebase review or second AI opinion — Codex walks the repo autonomously without you pasting code. Use for pre-release review, complex bug analysis, or validating invariants across a codebase.
---

# Codex CLI

Codex is an agentic AI that walks your codebase autonomously — you give it a question and a working directory; it reads files, runs searches, and reports findings. Requires OpenAI/ChatGPT Pro subscription.

## Key Distinction

- **Codex**: walks the repo itself, reads files, finds bugs without you pasting code
- **Gemini/orcx**: you pipe files or ask questions, model responds conversationally

Use Codex when the answer requires reading multiple files across the codebase.

## Sandbox Modes

| Mode                      | Flag                                         | Use when                                                |
| ------------------------- | -------------------------------------------- | ------------------------------------------------------- |
| Workspace-write (default) | `--full-auto`                                | Same repo, current working directory                    |
| Danger full access        | `-s danger-full-access`                      | Need to read system paths                               |
| No sandbox                | `--dangerously-bypass-approvals-and-sandbox` | Cross-repo (`../other-repo`) or files outside workspace |

**Rule of thumb:** If the code you want reviewed is under `./`, use `--full-auto`. If it's in `../`, use `--dangerously-bypass-approvals-and-sandbox -C /absolute/path/to/repo`.

## Code Review (Best Pattern)

```bash
# Review a specific commit
codex review --commit <sha>

# Review changes against base branch
codex review --base main

# Review with custom instructions, output to file
codex review "Focus on persistence correctness, memory safety, and invariant violations" \
  -o /tmp/codex-review.txt

# Review from a different working directory
codex review --commit <sha> -C /absolute/path/to/repo
```

## Freeform Analysis

```bash
# Ask about codebase (same repo, --full-auto default)
echo "Review src/vector/store/ for correctness bugs in the recovery path" \
  | codex exec --full-auto -o /tmp/codex-reply.txt

# Cross-repo (e.g., ../omendb from cloud repo)
cat /tmp/review-prompt.txt \
  | codex exec --dangerously-bypass-approvals-and-sandbox \
    -C /absolute/path/to/repo \
    -o /tmp/codex-reply.txt
```

## How `-o` Works

`-o <file>` writes the **model's last message** to the file — not a file Codex creates internally. The prompt does NOT need to say "write to /tmp/reply.txt". Just ask the question; the response goes to the file automatically.

## Parallel Pre-Release Review Pattern

Run all three reviewers in parallel with `jb`:

```bash
# Background Codex review
jb run "codex review 'Correctness and safety review of persistence layer' -o /tmp/codex-review.txt" --follow

# Background Gemini review
jb run "cat src/key-file.rs | gemini 'Full correctness review, look for data loss bugs' > /tmp/gemini-review.txt" --follow

# Meanwhile: launch reviewer subagent in Claude
# Then synthesize all findings
```

## Writing an Effective Prompt

```
Review src/vector/store/ for correctness bugs.

Key invariants to check:
1. RecordStore::set() is NOT idempotent — WAL replay must be skipped when slim snapshot loaded
2. dirty_since_flush must accumulate across checkpoints
3. set_pending_merge_dir must be called on every persistent SegmentManager

Focus on: recovery path, crash safety, data loss scenarios.
Report findings with file:line references.
```

**Be specific about invariants** — Codex finds real bugs when given precise constraints to verify.

## Common Issues

| Issue                  | Fix                                                            |
| ---------------------- | -------------------------------------------------------------- |
| No output file         | `-o` requires the model to respond (it saves the last message) |
| Can't read `../` files | Use `--dangerously-bypass-approvals-and-sandbox -C /abs/path`  |
| Runs interactively     | Use `codex exec`, not bare `codex`                             |
| Slow / times out       | Break into focused sub-questions                               |
