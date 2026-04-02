---
name: research
description: Use when researching unfamiliar patterns, evaluating tools or libraries, comparing approaches, or answering "what's the best way" questions with web, docs, and code search.
---

# Research

Research topics using web, docs, and code search. Scale depth to complexity.

## Triggers

- "research X", "look into X", "investigate X"
- "what's the best way to", "how should I"
- "what library for", "which approach"
- Before implementing an unfamiliar feature
- Evaluating libraries or tools

## Depth Scaling

| Complexity | Example                           | Sources               | Output                        |
| ---------- | --------------------------------- | --------------------- | ----------------------------- |
| **Quick**  | "best JSON library for rust"      | 1-2 sources           | 2-3 options, pick one         |
| **Medium** | "auth patterns for API"           | Multiple sources      | Options table, recommendation |
| **Deep**   | "distributed system architecture" | All sources, parallel | Full analysis and tradeoffs   |

Assess first: how consequential is this decision? Scale depth accordingly.

## Sources

| Query Type                  | Best Tool  | Notes                           |
| --------------------------- | ---------- | ------------------------------- |
| Library or framework docs   | Context7   | Resolve ID first, LLM-optimized |
| Code examples, API patterns | Exa        | `get_code_context_exa`          |
| General web, news, articles | Web search | Built-in or Exa                 |
| Local patterns              | Read/Grep  | Check the codebase first        |

## Process

1. Search in parallel across the right sources.
2. Prioritize official docs, recent content, and high-signal references.
3. Synthesize findings into an actionable recommendation.
4. Cite sources with links.

## Output

```markdown
# Research: [Topic]

## Summary

[2-3 sentence TL;DR]

## Key Findings

### Best Practices

- [Finding 1]
- [Finding 2]

### Options Considered

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A      | ...  | ...  |
| B      | ...  | ...  |

### Recommended Approach

[What to do and why]

## Code Examples

[Relevant snippets if applicable]

## Sources

- [Title](url)
```
