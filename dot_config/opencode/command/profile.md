---
description: Deep performance analysis using profiler subagent.
---

# Performance Profiling

Launch profiler subagent for deep performance analysis.

## Workflow

1. **Identify target** - specific code, function, or general slowness
2. **Launch profiler subagent**
3. **Report findings** with evidence and recommendations

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
