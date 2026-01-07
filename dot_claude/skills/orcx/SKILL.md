---
name: orcx-consult
description: >
  Get second opinion from other models via orcx.
  Triggers on: "ask deepseek", "second opinion", "what does deepseek think",
  "consult another model", "check with deepseek", "trading logic review",
  "quant review", "verify this logic".
  Use when uncertain about trading/financial logic or want model comparison.
allowed-tools: Read, Bash
---

# orcx - LLM Orchestrator

Consult other models for second opinions, especially for trading/quant logic.

## Available Agents

```bash
orcx agents  # List configured agents
```

Current: `fast` → DeepSeek v3.2 (quant firm model, strong on trading logic)

## Usage

```bash
# Simple query
orcx run "Your prompt here"

# With specific agent
orcx run -a fast "Your prompt here"

# Pipe context
cat file.py | orcx run "Review this trading logic"
```

## When to Use

- Trading/financial logic uncertainty
- Algorithm correctness verification
- Quant-specific questions (DeepSeek was built by a quant firm)
- Want diverse model perspectives
- Logic bugs that might benefit from fresh eyes

## Workflow

1. Identify the specific logic/code to review
2. Formulate clear, focused question
3. Include relevant context (code snippet, constraints)
4. Run via orcx
5. Compare response with your analysis
6. Synthesize insights

## Example

```bash
orcx run -a fast "Review this trading logic for edge cases:

def calculate_position_size(balance, risk_pct, entry, stop_loss):
    risk_amount = balance * risk_pct
    price_diff = abs(entry - stop_loss)
    return risk_amount / price_diff

What happens when entry equals stop_loss?"
```
