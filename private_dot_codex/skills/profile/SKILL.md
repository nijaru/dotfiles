---
name: profile
description: >
  Deep performance analysis and profiling.
  Triggers on: "profile", "performance", "slow", "optimize", "bottleneck".
metadata:
  short-description: Performance analysis and profiling
---

# Performance Profiling

Deep performance analysis for identifying bottlenecks and optimization opportunities.

## Triggers

- "profile this", "performance issue", "it's slow"
- "optimize", "bottleneck", "speed up"
- "why is this taking so long?"

## Analysis Focus

1. Measure baseline first (don't guess)
2. Identify hot paths from profiling data
3. Analyze: complexity, allocations, I/O, concurrency, caching
4. Recommend optimizations with expected impact
5. Persist findings to ai/review/ with before/after measurements

Evidence-based only. No assumptions.

## Output Format

```
## Performance Analysis

Target: [what was analyzed]
Baseline: [measured performance]

## Findings

1. [Bottleneck] - [measurement] - [impact]
2. ...

## Recommendations

| Fix | Expected Impact | Effort |
|-----|-----------------|--------|
| ... | ...             | ...    |

## Next Steps

1. [Specific action]
2. [Specific action]
```
