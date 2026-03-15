---
name: twitter
description: Use when needing real-time X/Twitter data (trends, sentiment, specific tweets) via Grok.
allowed-tools: Bash
---

# Twitter / X (Grok)

Retrieve and analyze real-time data from X/Twitter using the `orcx` CLI.

## 🎯 Mandates

- **Scope:** ONLY use for X/Twitter data. Use `codex` or `gemini` for code/technical tasks.
- **Freshness:** Always prioritize real-time queries for trending topics.

## 🛠️ Standards

### Common Queries
```bash
# General search
orcx -a grok "What are the top 3 trends in AI on Twitter right now?"

# Sentiment analysis
cat feedback.txt | orcx -a grok "Analyze the Twitter sentiment toward these features"

# Persistence
orcx -a grok "Query" -o response.md  # Save output
orcx -c "Follow-up"                  # Continue context
```

### CLI Reference
- `orcx agents`: List available agents.
- `orcx conversations list`: Review past interactions.
- `orcx --no-save`: Execute one-off queries without history.

## 🚫 Anti-Rationalization
| Excuse | Reality |
| :--- | :--- |
| "I'll just guess the sentiment" | Twitter sentiment changes hourly; use Grok for accuracy. |
| "Using this for code review" | Grok is for social data; use specialized coding skills for code. |
