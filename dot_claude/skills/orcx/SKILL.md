---
description: Get second opinion from other models via orcx or gemini CLI. Triggers on: "ask deepseek", "ask gemini", "orcx".
allowed-tools: Read, Bash
---

# Second Opinions from Other Models

Consult other models for second opinions. Version 0.0.5.

## Gemini (Preferred for Google Models)

Use the native `gemini` CLI for Gemini models (authenticated with subscription):

```bash
# One-shot query
gemini "Your prompt here"

# With file context
gemini -f file.py "Review this code"

# Pipe context
cat file.py | gemini "Review this code"

# Continue interactively after prompt
gemini -i "Start with this question"

# JSON output
gemini -o json "Your prompt here"
```

## orcx (Other Models)

Run `orcx agents` to see configured agents (DeepSeek, Grok, etc.).

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

orcx stores conversations in SQLite (~/.config/orcx/conversations.db).

```bash
# Continue last conversation
orcx run -c "Follow-up question"

# Resume specific conversation by ID
orcx run --resume abc1 "More context"

# Don't save this exchange
orcx run --no-save "Quick question"

# List recent conversations
orcx conversations list

# Show conversation history
orcx conversations show abc1

# Clean old conversations (30+ days)
orcx conversations clean
```

## When to Use

- Want a second opinion on logic or approach
- Comparing model perspectives
- Leveraging model-specific strengths
- Fresh eyes on a problem
- Multi-turn discussions with cheaper models

## Workflow

1. Identify the specific question or code to review
2. Formulate clear, focused prompt
3. Include relevant context (pipe or `-f`)
4. Run via orcx
5. Continue conversation with `-c` if needed
6. Compare response with your analysis
7. Synthesize insights
