---
name: orcx-consult
description: >
  Get second opinion from other models via orcx.
  Triggers on: "ask deepseek", "ask gemini", "orcx".
allowed-tools: Read, Bash
---

# orcx - LLM Orchestrator

Consult other models for second opinions.

## Available Agents

- `fast` → DeepSeek v3.2 (via OpenRouter)
- `gemini` → Gemini 3 Flash Preview

## Usage

```bash
# Simple query
orcx run "Your prompt here"

# With specific agent
orcx run -a fast "Your prompt here"

# Pipe context
cat file.py | orcx run "Review this code"
```

## When to Use

- Want a second opinion on logic or approach
- Comparing model perspectives
- Leveraging model-specific strengths
- Fresh eyes on a problem

## Workflow

1. Identify the specific question or code to review
2. Formulate clear, focused prompt
3. Include relevant context
4. Run via orcx
5. Compare response with your analysis
6. Synthesize insights
