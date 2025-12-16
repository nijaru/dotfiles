---
name: research
description: >
  Deep research using web, docs, and code search.
  Triggers on: "research", "look into", "what's the best", "how should I",
  evaluating libraries, unfamiliar patterns, state of the art.
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__exa__web_search_exa, mcp__exa__get_code_context_exa, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
---

# Research

Research topics using web, docs, and code search. Scale depth to complexity.

## Triggers

- "research X", "look into X", "investigate X"
- "what's the best way to", "how should I"
- "what library for", "which approach"
- Before implementing unfamiliar feature
- Evaluating libraries/tools
- Understanding state of the art

## Depth Scaling

| Complexity | Example                           | Sources               | Output                             |
| ---------- | --------------------------------- | --------------------- | ---------------------------------- |
| **Quick**  | "best JSON library for rust"      | 1-2 sources           | 2-3 options, pick one              |
| **Medium** | "auth patterns for API"           | Multiple sources      | Options table, recommendation      |
| **Deep**   | "distributed system architecture" | All sources, parallel | Full analysis, tradeoffs, diagrams |

**Assess first**: How consequential is this decision? Scale depth accordingly.

## Sources (Use Best Tool for Task)

| Query Type                  | Best Tool         | Notes                           |
| --------------------------- | ----------------- | ------------------------------- |
| General web, news, articles | `WebSearch`       | Built-in, simple                |
| Fetch specific URL          | `WebFetch`        | Summarizes content              |
| Library/framework docs      | `Context7`        | Resolve ID first, LLM-optimized |
| Code examples, API patterns | `Exa`             | `get_code_context_exa`          |
| Complex multi-hop           | `Parallel agents` | Task tool                       |
| Local patterns              | `Read/Grep/Glob`  | Check codebase first            |

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
- [Title](url)
```
