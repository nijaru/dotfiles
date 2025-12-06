---
description: Deep research on a topic using web, docs, and code search
argument-hint: "<topic>"
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
---

Research the given topic, scaling depth to complexity.

$ARGUMENTS

---

## Depth Scaling

| Complexity | Example                           | Sources                      | Output                             |
| ---------- | --------------------------------- | ---------------------------- | ---------------------------------- |
| **Quick**  | "best JSON library for rust"      | 1-2 searches, Context7       | 2-3 options, pick one              |
| **Medium** | "auth patterns for API"           | Web + Context7, 1 pass       | Options table, recommendation      |
| **Deep**   | "distributed system architecture" | Multiple passes, all sources | Full analysis, tradeoffs, diagrams |

**Assess first**: How consequential is this decision? How many viable options exist? Scale accordingly.

---

## Sources (Query in Parallel)

### 1. Web Search (General)

- Current best practices
- Recent articles/discussions (2024-2025)
- Official announcements

### 2. Library Docs (Context7)

- Resolve library ID first (`resolve-library-id`)
- Fetch focused documentation (`get-library-docs`)
- LLM-optimized code snippets

### 3. Codebase (Local)

- How does this project currently handle it?
- Existing patterns to follow

---

## Process

1. **Parallel search**: Hit all sources simultaneously
2. **Filter noise**: Prioritize official docs, recent content, high-quality sources
3. **Synthesize**: Combine findings into actionable summary
4. **Cite sources**: Include links for reference

---

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

---

## When to Use

- Before implementing unfamiliar feature
- Evaluating libraries/tools
- Understanding state of the art
- Finding best practices for a pattern
