---
name: ask
description: Use when needing X/Twitter data via Grok, or a second opinion from Gemini or Codex on any task — code review, debugging, analysis, architecture questions. Grok is ONLY for social/X data.
allowed-tools: Read, Bash
---

# Ask Other Models

External AI CLIs for second opinions and social data. All subscription-based (no extra API cost).

## When to Use

| Tool     | Use for                                                                     |
| -------- | --------------------------------------------------------------------------- |
| `gemini` | Second opinion on any task — code review, debugging, analysis, architecture |
| `codex`  | Same as Gemini but agentic — walks the repo itself → see `codex` skill      |
| `orcx`   | X/Twitter data ONLY — Grok has real-time X search access                    |

Gemini and Codex are interchangeable for most tasks. Use Codex when you want it to read files autonomously; use Gemini when you want to pipe specific files yourself.

## Gemini CLI

```bash
# Second opinion on anything
gemini "Your question here"

# Pipe files for review
cat src/file.rs | gemini "Correctness review — look for bugs and invariant violations"

# Multiple files
cat src/a.rs src/b.rs | gemini "Review these together"

# Save output
gemini "Your prompt" > /tmp/gemini-reply.txt 2>/dev/null

# JSON output
gemini -o json "Your prompt" 2>/dev/null | jq -r .response
```

Gemini has a 1M token context — pipe aggressively.

## Grok via orcx (X/Twitter Data Only)

```bash
# Query with Grok agent
orcx -a grok "What are people saying about X on Twitter right now?"

# Check available agents
orcx agents

# Pipe context + save
orcx -a grok "Query" -o response.md

# Continue last conversation
orcx -c "Follow-up question"
```

**Do not use Grok for code review or technical analysis** — use Gemini or Codex instead.

## Parallel Multi-Model Review

Run all reviewers in parallel for comprehensive coverage before a release:

```bash
# Codex: agentic walk (see codex skill for full options)
jb run "codex review 'Safety and correctness review' -o /tmp/codex-review.txt"

# Gemini: focused file review
jb run "cat src/key/*.rs | gemini 'Full correctness review, look for data loss bugs' > /tmp/gemini-review.txt"

# Claude: reviewer subagent launched from within Claude Code
```
