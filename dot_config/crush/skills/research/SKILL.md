---
name: research
description: >
  Deep research using web, docs, and code search.
  Triggers on: "research", "look into", "what's the best", "how should I",
  evaluating libraries, unfamiliar patterns, state of the art.
metadata:
  short-description: Research topics using web and code search
---

# Research

Research topics using web, docs, and code search. Scale depth to complexity.

## Triggers

- "research X", "look into X", "investigate X"
- "what's the best way to", "how should I"
- "what library for", "which approach"
- Before implementing unfamiliar feature
- Evaluating libraries/tools

## Depth Scaling

| Complexity | Example                           | Sources               | Output                             |
| ---------- | --------------------------------- | --------------------- | ---------------------------------- |
| **Quick**  | "best JSON library for rust"      | 1-2 sources           | 2-3 options, pick one              |
| **Medium** | "auth patterns for API"           | Multiple sources      | Options table, recommendation      |
| **Deep**   | "distributed system architecture" | All sources, parallel | Full analysis, tradeoffs, diagrams |

**Assess first**: How consequential is this decision? Scale depth accordingly.

## Sources (Use Best Tool for Task)

| Query Type                  | Best Tool  | Notes                           |
| --------------------------- | ---------- | ------------------------------- |
| Library/framework docs      | Context7   | Resolve ID first, LLM-optimized |
| Code examples, API patterns | Exa        | get_code_context_exa            |
| General web, news, articles | Web search | Built-in or Exa                 |
| Local patterns              | Read/Grep  | Check codebase first            |

## Process

1. **Parallel search**: Hit all sources simultaneously
2. **Filter noise**: Prioritize official docs, recent content, high-quality sources
3. **Synthesize**: Combine findings into actionable summary
4. **Cite sources**: Include links for reference

## Output Format

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
