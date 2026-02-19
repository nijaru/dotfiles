---
name: gemini
description: Use when needing a second opinion from Gemini on any task — code review, debugging, analysis, architecture. Best when you want to pipe specific files yourself rather than letting an agent walk the repo.
---

# Gemini CLI

Gemini is Google's AI CLI for second opinions. Pipe files directly — its 1M token context handles entire modules or codebases at once. Requires Google subscription (Gemini Advanced).

## Key Distinction from Codex

- **Gemini**: you pipe files, it responds — fast, direct, good for targeted review
- **Codex**: walks the repo itself autonomously — good when you don't want to select files manually

## Quick Reference

```bash
# One-shot question or analysis
gemini "Your question here"

# Pipe a file for review
cat src/file.rs | gemini "Correctness review — look for data loss bugs and invariant violations"

# Pipe multiple files together
cat src/a.rs src/b.rs | gemini "Review these two files together, focus on their interaction"

# Pipe an entire module
cat src/vector/store/*.rs | gemini "Architecture and correctness review of the store module"

# Save output to file
gemini "Your prompt" > /tmp/gemini-reply.txt 2>/dev/null

# JSON output with metadata
gemini -o json "Your prompt" 2>/dev/null | jq -r .response
```

## Effective Prompts for Code Review

Give Gemini specific invariants to verify — vague prompts get vague answers:

```
Full correctness review of this persistence layer.

Key invariants to verify:
1. WAL replay must be skipped when slim snapshot is loaded
2. dirty_since_flush must accumulate across checkpoints
3. set_pending_merge_dir must be called on every persistent SegmentManager

Look for: data loss scenarios, crash safety issues, incorrect recovery behavior.
Report findings with file:line references. Be specific about what can go wrong.
```

## Large Codebase Pattern

Gemini's 1M context is the main advantage — don't undersell it:

```bash
# Entire Rust source tree
find src -name "*.rs" | xargs cat | gemini "Architecture review: identify coupling issues, missing abstractions, and correctness risks"

# Specific subsystem
cat src/vector/store/*.rs src/omen/*.rs | gemini "Review the persistence layer end-to-end"
```

## Parallel Review Pattern

Run alongside Codex and a Claude reviewer subagent:

```bash
jb run "cat src/key/*.rs | gemini 'Full correctness review' > /tmp/gemini-review.txt" --follow
```
