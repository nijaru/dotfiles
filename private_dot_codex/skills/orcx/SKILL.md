---
name: orcx
description: >
  Get second opinion from other models via orcx.
  Triggers on: "ask deepseek", "ask gemini", "orcx", "second opinion".
metadata:
  short-description: Multi-model orchestrator
---

# orcx - LLM Orchestrator

Consult other models for second opinions.

## Triggers

- "ask deepseek", "ask gemini", "ask grok"
- "orcx", "second opinion"
- "what does [model] think?"

## Usage

```bash
# Simple query
orcx run "Your prompt here"

# With specific agent
orcx run -a fast "Your prompt here"

# Pipe context
cat file.py | orcx run "Review this code"

# Include file context
orcx run -f file.py "Review this code"

# Save response to file
orcx run -o response.md "Explain this concept"
```

## Conversations

```bash
# Continue last conversation
orcx run -c "Follow-up question"

# Resume specific conversation by ID
orcx run --resume abc1 "More context"

# Don't save this exchange
orcx run --no-save "Quick question"

# List recent conversations
orcx conversations list

# Clean old conversations (30+ days)
orcx conversations clean
```

## When to Use

- Want a second opinion on logic or approach
- Comparing model perspectives
- Leveraging model-specific strengths
- Fresh eyes on a problem
- Multi-turn discussions with cheaper models

Run `orcx agents` to see configured agents.
