---
name: ask
description: Use when needing X/Twitter data via Grok, or Google-specific capabilities via Gemini CLI.
allowed-tools: Read, Bash
---

# Ask Other Models

Access model-specific capabilities: Grok for X/Twitter data, Gemini for Google models.

## When to Use

| Tool     | Use for                                             |
| -------- | --------------------------------------------------- |
| `orcx`   | X/Twitter data — Grok has real-time X search access |
| `gemini` | Google models (authenticated subscription)          |

Not for general second opinions — Claude handles those better.

## Grok via orcx (X/Twitter Data)

```bash
# Check available agents and current model IDs
orcx agents

# Query with Grok agent
orcx -a grok "What are people saying about X on Twitter right now?"

# Pipe context
cat file.py | orcx -a grok "Review this"

# Save to file
orcx -a grok "Query" -o response.md
```

## Gemini CLI

```bash
# One-shot query
gemini "Your prompt here"

# Pipe context
cat file.py | gemini "Review this code"

# Save output
gemini "Your prompt here" > response.md 2>/dev/null

# JSON with stats
gemini -o json "Your prompt" 2>/dev/null | jq -r .response
```

## orcx Reference

```bash
# Continue last conversation
orcx -c "Follow-up"

# Include file context
orcx -f file.py "Review this"

# Don't save
orcx --no-save "Quick question"

# List conversations
orcx conversations list
```
