---
name: twitter
description: Use when needing real-time X/Twitter data — what people are saying, trending topics, social sentiment. Uses Grok via orcx CLI. Not for code review or technical tasks.
---

# Twitter / X Data via Grok

Access real-time X/Twitter data through Grok using the `orcx` CLI.

**Only use for X/Twitter data.** For code review or second opinions, use the `gemini` or `codex` skills.

## Quick Reference

```bash
# Query Grok
orcx -a grok "What are people saying about X on Twitter right now?"

# Check available agents and model IDs
orcx agents

# Pipe context
cat file.txt | orcx -a grok "Summarize reactions to this"

# Save output
orcx -a grok "Query" -o response.md

# Continue last conversation
orcx -c "Follow-up question"

# Include a file
orcx -f file.txt "What do people think of this?"

# One-off without saving
orcx --no-save "Quick question"

# List past conversations
orcx conversations list
```
