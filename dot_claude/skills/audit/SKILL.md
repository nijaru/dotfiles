---
name: audit
description: >
  Run external AI audit using DeepSeek via OpenCode.
  Triggers on: "audit with deepseek", "second opinion", "external review"
allowed-tools: Bash
---

# External Audit

Run codebase audit using DeepSeek via OpenCode for a second opinion.

## Triggers

- "audit with deepseek", "get a second opinion"
- "external audit", "deepseek review"
- When user wants independent verification

## Usage

```bash
# Security audit
opencode run "Audit this codebase for security vulnerabilities. Report with file:line references." -m openrouter/deepseek/deepseek-v3.2

# Architecture review
opencode run "Review the architecture of this codebase. Identify coupling issues, missing abstractions, and suggest improvements." -m openrouter/deepseek/deepseek-v3.2

# Code quality
opencode run "Analyze code quality: naming, complexity, duplication, test coverage gaps." -m openrouter/deepseek/deepseek-v3.2
```

## Models Available

| Model                               | Via         | Best For      |
| ----------------------------------- | ----------- | ------------- |
| `openrouter/deepseek/deepseek-v3.2` | OpenRouter  | General audit |
| `huggingface/zai-org/GLM-4.6`       | HuggingFace | Alternative   |
| `google/gemini-3-flash-preview`     | Google      | Fast review   |

## Output

Relay the OpenCode output back to the user with key findings highlighted.
