---
description: Deep performance analysis using profiler subagent
allowed-tools: Read, Grep, Glob, Bash, Task
---

Launch profiler subagent for deep performance analysis.

1. **Identify target**: Specific code, function, or general slowness
2. **Spawn profiler subagent** via Task tool (`subagent_type: profiler`)
3. **Profiler will**:
   - Measure baseline first (no guessing)
   - Identify hot paths from profiling data
   - Analyze: complexity, allocations, I/O, concurrency, caching
   - Recommend optimizations with expected impact
   - Persist findings to ai/review/

Output format:

```
## Performance Analysis
Target: [what]
Baseline: [measurement]

## Findings
1. [Bottleneck] - [measurement] - [impact]

## Recommendations
| Fix | Expected Impact | Effort |
|-----|-----------------|--------|

## Next Steps
1. [Action]
```
