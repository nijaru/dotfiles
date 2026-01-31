---
name: ask
description: Get second opinion from other models via gemini CLI or orcx.
allowed-tools: Read, Bash
---

# Second Opinions from Other Models

Consult other models for second opinions.

## Gemini (Preferred for Google Models)

Use the native `gemini` CLI for Gemini models (authenticated with subscription).
Output goes to stdout; save to file to capture results.

```bash
# One-shot query (output to stdout)
gemini "Your prompt here"

# Save response to file
gemini "Your prompt here" > response.md 2>/dev/null

# Pipe file context
cat file.py | gemini "Review this code" > review.md 2>/dev/null

# JSON output with stats
gemini -o json "Your prompt here" 2>/dev/null | jq -r .response

# Continue interactively after prompt
gemini -i "Start with this question"
```

## orcx (Other Models)

Run `orcx agents` to see configured agents (DeepSeek, Grok, etc.).

## Usage

```bash
# Simple query (uses default model)
orcx "Your prompt here"

# With specific agent
orcx -a fast "Your prompt here"

# Pipe context
cat file.py | orcx "Review this code"

# Include file context
orcx -f file.py "Review this code"

# Save response to file
orcx -o response.md "Explain this concept"

# Explicit run subcommand (equivalent)
orcx run -a fast "Your prompt here"
```

## Conversations

orcx stores conversations in SQLite (~/.config/orcx/conversations.db).

```bash
# Continue last conversation
orcx -c "Follow-up question"

# Resume specific conversation by ID
orcx --resume abc1 "More context"

# Don't save this exchange
orcx --no-save "Quick question"

# List recent conversations
orcx conversations list

# Show conversation history
orcx conversations show abc1

# Clean old conversations (30+ days)
orcx conversations clean
```

## When to Use

| Tool     | Use for                                         |
| -------- | ----------------------------------------------- |
| `gemini` | Google models (authenticated with subscription) |
| `orcx`   | DeepSeek, Grok, other OpenRouter models         |

- Second opinion on logic or approach
- Comparing model perspectives
- Leveraging model-specific strengths
- Fresh eyes on a problem

## Workflow

1. Identify the specific question or code to review
2. Formulate clear, focused prompt
3. Include relevant context (pipe or `-f` for orcx, pipe or stdin for gemini)
4. Run via `gemini` or `orcx`
5. Save output to file if needed for reference
6. Compare response with your analysis
7. Synthesize insights
